class CharactersController < ApplicationController
  verify :only => [:create, :new],
         :session => :registering || :admin,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}
         
  verify :only => [:edit, :destroy],
         :session => :admin,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}
         
  # GET /characters
  # GET /characters.xml
  def index
    @characters = Character.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @characters }
    end
  end  



  def skills
    
    @character = Character.find(params[:id])

  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
    @character = Character.find(params[:id])
    @ship = @character.ship

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/new
  # GET /characters/new.xml
  def new
    @character = Character.new
    @character.total_points = 3

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id])

      if request.post?
        @character.update_attributes(params[:character])
        redirect_to :action => 'edit', :id => @character.id
      end
    end

  

  # POST /characters
  # POST /characters.xml
  def create
    @character = Character.new(params[:character])
    @character.user_id = session[:user_id]
    @character.total_points = 3
    @character.lvl= 1
    @character.exp=1
    @character.gold = 500
    @character.lucky = 0
    @character.penny = 0
    @character.goldrush = 0
    @character.cannonmastery = 0
    @character.trueshot = 0
    @character.shootingblind = 0
    @character.olsturdy = 0
    @character.smoothsailing = 0
    @character.cargoreduction = 0
    @character.exp_next= 10
    

    
    respond_to do |format|
      if @character.save 
        session[:character_id] = @character.id
        flash[:notice] = 'Character was successfully created.'
        format.html { redirect_to :action => 'new', :controller => 'ships' }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

 #update the character and its attributes
  def update

    @character = Character.find(params[:id])

    respond_to do |format|
    params[:character].keys do |key|
      if params[:character][key] == ""
        params[:character][key] = "0"
      end
    end
    if @character.update_attributes(params[:character])

        flash[:notice] = 'Character was successfully updated.'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
        
      else
        flash[:notice] = 'You did not correctly assign your skill points.'
        format.html { redirect_to(@character) }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      
    end
  end
end

#Delete a character
  def destroy
    @character = Character.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to(characters_url) }
      format.xml  { head :ok }
    end
  end
end
