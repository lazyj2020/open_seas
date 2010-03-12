class ShipAttributesController < ApplicationController
  # GET /ship_attributes
  # GET /ship_attributes.xml
  def index
    @ship_attributes = ShipAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ship_attributes }
    end
  end

  # GET /ship_attributes/1
  # GET /ship_attributes/1.xml
  def show
    @ship_attribute = ShipAttribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ship_attribute }
    end
  end

  # GET /ship_attributes/new
  # GET /ship_attributes/new.xml
  def new
    @ship_attribute = ShipAttribute.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ship_attribute }
    end
  end

  # GET /ship_attributes/1/edit
  def edit
    @ship_attribute = ShipAttribute.find(params[:id])
  end

  # POST /ship_attributes
  # POST /ship_attributes.xml
  def create
    @ship_attribute = ShipAttribute.new(params[:ship_attribute])
    @ship_attribute.ship_id = current_character.ship.id



    respond_to do |format|
      if @ship_attribute.save
        flash[:notice] = 'ShipAttribute was successfully created.'
        format.html { redirect_to(@ship_attribute) }
        format.xml  { render :xml => @ship_attribute, :status => :created, :location => @ship_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ship_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ship_attributes/1
  # PUT /ship_attributes/1.xml
  def update
    @ship_attribute = ShipAttribute.find(params[:id])

    respond_to do |format|
      if @ship_attribute.update_attributes(params[:ship_attribute])
        flash[:notice] = 'ShipAttribute was successfully updated.'
        format.html { redirect_to(@ship_attribute) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ship_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ship_attributes/1
  # DELETE /ship_attributes/1.xml
  def destroy
    @ship_attribute = ShipAttribute.find(params[:id])
    @ship_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(ship_attributes_url) }
      format.xml  { head :ok }
    end
  end
end
