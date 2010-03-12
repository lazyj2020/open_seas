class ShipsController < ApplicationController
  verify :only => [:create, :new],
         :session => :registering || :admin,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}
         
  verify :only => [:edit, :update, :destroy],
         :session => :admin,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}
         
  verify :only => [:move],
         :session => :user_id,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}

  
  # GET /ships
  # GET /ships.xml
  def index
    @ships = Ship.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ships }
    end
  end

  # GET /ships/1
  # GET /ships/1.xml
  def show
    @ship = Ship.find(params[:id])
    
    @ordereditems = ShipItem.find(:all, :conditions => {:ship_id => "#{@ship.id}"}, :joins => :item, :order => "slot")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ship }
    end
  end

  # GET /ships/new
  # GET /ships/new.xml
  def new
    @ship = Ship.new
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ship }
    end
  end

  # GET /ships/1/edit
  def edit
    @ship = Ship.find(params[:id])
  end

  # POST /ships
  # POST /ships.xml
  def create
    
    @ship = Ship.new(params[:ship])
    @ship.character_id = session[:character_id]
    @ship.port_id = 7
    @ship.save
    
    @ship_attribute = ShipAttribute.new()
    @ship_attribute.ship_id = @ship.id
    @ship_attribute.cargo = 100
    @ship_attribute.weapon_slot = 2
    @ship_attribute.mast_slot = 2
    @ship_attribute.crew_slot = 1
    @ship_attribute.custom_slot = 0
    @ship_attribute.rudder_slot = 1
    @ship_attribute.structure = 50
    @ship.update_attribute(:curr_hp, "#{@ship_attribute.structure}")
    
    @ship.create_std_items
    
    respond_to do |format|
    @ship_attribute.save
        session.delete(:registering)
        session[:character_id] = nil
        flash[:notice] = 'Ship was successfully created.'
        format.html { redirect_to(@ship) }
        format.xml  { render :xml => @ship, :status => :created, :location => @ship }
    end
  end

  # PUT /ships/1
  # PUT /ships/1.xml
  def update
    @ship = Ship.find(params[:id])

    respond_to do |format|
      if @ship.update_attributes(params[:ship])
        flash[:notice] = 'Ship was successfully updated.'
        format.html { redirect_to(@ship) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ships/1
  # DELETE /ships/1.xml
  def destroy
    @ship = Ship.find(params[:id])
    @ship.destroy

    respond_to do |format|
      format.html { redirect_to(ships_url) }
      format.xml  { head :ok }
    end
  end
  
  def move
    @ship = User.find(session[:user_id]).character.ship
    @ordereditems = ShipItem.find(:all, :conditions => {:ship_id => "#{@ship.id}"}, :joins => :item, :order => "slot")
    @destinations = @ship.port.ends
    @atk_options = Option.find(:all, :conditions =>{:typ => 'atk'})
    @flee_options = Option.find(:all, :conditions =>{:typ => 'flee'})
  end
  
  def move_ship
    if (current_cargo < current_ship.cargo)
      @route = Route.find(:first, :conditions => { :start_id => current_ship.port.id, :end_id => params[:ship][:port_id] })
      @time_task = TimeTask.new(
        :name => "moving #{current_ship.name}",
        :task => 'move_ship',
        :param1 => current_ship.id,
        :param2 => params[:ship][:port_id],
        :param3 => @route.common_id,
        :when => (@route.distance / current_ship.speed).seconds.from_now
      )
      #determine if battle
      @tasks = TimeTask.find(:all, :conditions => {:param3 => @route.common_id, :task => 'move_ship'})
      current_ship.update_attribute(:aggressive,"#{ params[:ship][:aggressive] }")
      current_ship.update_attribute(:attack_mod_type,"#{ params[:ship][:attack_mod_type] }")
      current_ship.update_attribute(:attack_mod_num,"#{ params[:ship][:attack_mod_num] }")
      current_ship.update_attribute(:flee,"#{ params[:ship][:flee] }")
      current_ship.update_attribute(:flee_mod_type,"#{ params[:ship][:flee_mod_type] }")
      current_ship.update_attribute(:flee_mod_num,"#{ params[:ship][:flee_mod_num] }")
      
      
      
      @tasks.each do |task|
        enemy = Ship.find(task.param1)
        time_collide = nil
        if task.param2 != @time_task.param2
          time_collide = (((enemy.speed * (task.when - Time.now))) / (enemy.speed + current_ship.speed)).seconds.from_now
          Rails.logger.info("time = #{time_collide}")
        else
          if (@time_task.when <= task.when)
            time_collide = ((@route.distance - (enemy.speed * (task.when - Time.now))) / (current_ship.speed - enemy.speed)).from_now
          end
        end
        if time_collide != nil
          if enemy.aggressive == 1 and current_ship.aggressive == 1
            Rails.logger.info("both aggressive")
            @battle_task = TimeTask.new(
              :name => "battle between #{current_ship.name} and #{enemy.name}",
              :task => 'battle',
              :param1 => current_ship.id,
              :param2 => enemy.id,
              :when => time_collide
            )
            @battle_task.save
            
          
          else 
            if enemy.aggressive != current_ship.aggressive
              eva = 0
              if enemy.aggressive == 0
                eva = enemy.evasion / 10
              else
                eva = current_ship.evasion / 10
              end
              if eva <= rand(15)
                @battle_task = TimeTask.new(
                  :name => "battle between #{current_ship.name} and #{enemy.name}",
                  :task => 'battle',
                  :param1 => current_ship.id,
                  :param2 => enemy.id,
                  :when => time_collide
                )
              end
            end
          end
        end
      end
      #Rails.logger.info("PARAMS: #{params.inspect}")
      current_ship.update_attribute(:port_id,"1")
      respond_to do |format|
        if @time_task.save
          flash[:notice] = "Ship has set Sail!"
          format.html { redirect_to(current_ship) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @ship.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "Ship is over capacity, try selling or equipping"
      redirect_to(current_ship)
    end
  end
  
  def update_distance
    @destination = Port.find(params[:port_id])
    render :partial => 'show_distance'
  end


  def timer
    render :partial => "timer"
  end 
  
  def cargo
    @ship = Ship.find(params[:id])
    render :partial => "cargo"

  end
  
end

