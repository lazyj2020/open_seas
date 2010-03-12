class TimeTasksController < ApplicationController
  # GET /time_tasks
  # GET /time_tasks.xml
  def index
    @time_tasks = TimeTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @time_tasks }
    end
  end

  # GET /time_tasks/1
  # GET /time_tasks/1.xml
  def show
    @time_task = TimeTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @time_task }
    end
  end

  # GET /time_tasks/new
  # GET /time_tasks/new.xml
  def new
    @time_task = TimeTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @time_task }
    end
  end

  # GET /time_tasks/1/edit
  def edit
    @time_task = TimeTask.find(params[:id])
  end

  # POST /time_tasks
  # POST /time_tasks.xml
  def create
    @time_task = TimeTask.new(params[:time_task])

    respond_to do |format|
      if @time_task.save
        flash[:notice] = 'TimeTask was successfully created.'
        format.html { redirect_to(@time_task) }
        format.xml  { render :xml => @time_task, :status => :created, :location => @time_task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @time_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /time_tasks/1
  # PUT /time_tasks/1.xml
  def update
    @time_task = TimeTask.find(params[:id])

    respond_to do |format|
      if @time_task.update_attributes(params[:time_task])
        flash[:notice] = 'TimeTask was successfully updated.'
        format.html { redirect_to(@time_task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @time_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /time_tasks/1
  # DELETE /time_tasks/1.xml
  def destroy
    @time_task = TimeTask.find(params[:id])
    @time_task.destroy

    respond_to do |format|
      format.html { redirect_to(time_tasks_url) }
      format.xml  { head :ok }
    end
  end
end
