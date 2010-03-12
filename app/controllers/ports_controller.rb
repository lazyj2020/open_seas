class PortsController < ApplicationController
  verify :only => [:create, :new, :edit, :update, :destroy],
         :session => :admin || :registering,
         :add_flash => {:notice => 'You may not perform this action'},
         :redirect_to => {:action => 'index', :controller => 'site'}
         
  # GET /ports
  # GET /ports.xml
  def index
    @ports = Port.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ports }
    end
  end

  # GET /ports/1
  # GET /ports/1.xml
  def show
    @port = Port.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @port }
    end
  end

  # GET /ports/new
  # GET /ports/new.xml
  def new
    @port = Port.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @port }
    end
  end

  # GET /ports/1/edit
  def edit
    @port = Port.find(params[:id])
  end

  # POST /ports
  # POST /ports.xml
  def create
    @port = Port.new(params[:port])

    respond_to do |format|
      if @port.save
        flash[:notice] = 'Port was successfully created.'
        format.html { redirect_to(@port) }
        format.xml  { render :xml => @port, :status => :created, :location => @port }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @port.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ports/1
  # PUT /ports/1.xml
  def update
    @port = Port.find(params[:id])

    respond_to do |format|
      if @port.update_attributes(params[:port])
        flash[:notice] = 'Port was successfully updated.'
        format.html { redirect_to(@port) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @port.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ports/1
  # DELETE /ports/1.xml
  def destroy
    @port = Port.find(params[:id])
    @port.destroy

    respond_to do |format|
      format.html { redirect_to(ports_url) }
      format.xml  { head :ok }
    end
  end
end
