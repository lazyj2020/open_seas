class BattlesController < ApplicationController

#Battle Index
  def index
    @battles = Battle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @battles }
    end
  end

  #The battle Show formatter
  def show
    @battle = Battle.find(params[:id])
    @recaparray = @battle.recap.split(/\n/)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @battle }
    end
  end

  # GET /battles/1
  # GET /battles/1.xml
  def show_battle
    @battle = Battle.find(params[:id])
    @recaparray = @battle.recap.split(/\n/)
    @temp = TimeTask.find(:first, :conditions => {:task => "show_battle", :param1 => current_ship.id, :param2 => @battle.id})
    if @temp != nil
    @temp.destroy
    end
    flash[:notice] = nil
    render :partial => "battle"
  end


 #Create a new Battle
  def new
    @battle = Battle.new
    @ships = Ship.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @battle }
    end
  end

  # Edit the Battle
  def edit
    @battle = Battle.find(params[:id])
  end

  # POST /battles
  # POST /battles.xml
  def create
    @battle = Battle.new(params[:battle])
    
    @ship1 = Ship.find(@battle.ship1_id)
    @ship2 = Ship.find(@battle.ship2_id)
    @character = Character.find(1)
    @finished = Battle.battle(@ship1,@ship2)
        
    respond_to do |format|
      if @battle.save
        flash[:notice] = 'Battle was successfully created.'
        format.html { redirect_to(@finished) }
        format.xml  { render :xml => @battle, :status => :created, :location => @battle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @battle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /battles/1
  # PUT /battles/1.xml
  def update
    @battle = Battle.find(params[:id])

    respond_to do |format|
      if @battle.update_attributes(params[:battle])
        flash[:notice] = 'Battle was successfully updated.'
        format.html { redirect_to(@battle) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @battle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /battles/1
  # DELETE /battles/1.xml
  def destroy
    @battle = Battle.find(params[:id])
    @battle.destroy

    respond_to do |format|
      format.html { redirect_to(battles_url) }
      format.xml  { head :ok }
    end
  end
end
