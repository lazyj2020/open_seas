class NewsPostsController < ApplicationController
  layout 'application'
  # GET /news_posts
  # GET /news_posts.xml
  def index
    @news_posts = NewsPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_posts }
    end
  end

  # GET /news_posts/1
  # GET /news_posts/1.xml
  def show
    @news_post = NewsPost.find(params[:id], :conditions => [" Order by news_post.updated_at ASC"])
    @messages = @news_post.paginate :per_page => 10, :page => params[:page], :include => :news_post, :order => "news_post.updated_at ASC"
 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news_post }
    end
  end

  # GET /news_posts/new
  # GET /news_posts/new.xml
  def new
    @news_post = NewsPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_post }
    end
  end

  # GET /news_posts/1/edit
  def edit
    @news_post = NewsPost.find(params[:id])
  end

  # POST /news_posts
  # POST /news_posts.xml
  def create
    @news_post = NewsPost.new(params[:news_post])
    @news_post.author = current_user.account
    respond_to do |format|
      if @news_post.save
        flash[:notice] = 'Successfully Posted.'
        format.html { redirect_to(:action => "index", :controller => "user") }
        format.xml  { render :xml => @news_post, :status => :created, :location => @news_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news_posts/1
  # PUT /news_posts/1.xml
  def update
    @news_post = NewsPost.find(params[:id])

    respond_to do |format|
      if @news_post.update_attributes(params[:news_post])
        flash[:notice] = 'Successfully Updated.'
        format.html { redirect_to(:action => "index", :controller => "user" ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /news_posts/1
  # DELETE /news_posts/1.xml
  def destroy
    @news_post = NewsPost.find(params[:id])
    @news_post.destroy

    respond_to do |format|
      format.html { redirect_to(:action => "index", :controller => "user") }
      format.xml  { head :ok }
    end
  end
end
