class UserController < ApplicationController
  include ApplicationHelper

  def index
    @news_posts = NewsPost.find(:all, :order => ["created_at DESC"])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_posts }
    end
  end

  def  login 
    @title = "Log in to Open Seas" 
    if request.get? 
      @user = User.new(:remember_me => cookies[:remember_me] || "0") 
    elsif param_posted?(:user) 
      @user = User.new(params[:user]) 
      user = User.find_by_account_and_password(@user.account, @user.give_encrypted(@user.password))
      if user 
        user.login!(session)
        if admin?
          session[:admin] = true;
        end
        if @user.remember_me == "1" 
          cookies[:remember_me] = { :value => "1", :expires => 10.years.from_now } 
          user.authorization_token = user.id 
          user.save! 
          cookies[:authorization_token] = { :value => user.authorization_token, :expires  => 10.years.from_now }
        else
          cookies.delete(:remember_me) 
          cookies.delete(:authorization_token)
        end 
        flash[:notice] = "User #{user.account} logged  in!"
        #redirect_to Character.find_by_user_id(user.id)
        redirect_to :action => "index", :controller => "user" 
      else 
        # Don't  show  the  password   again  in the  view. 
        @user.clear_password!
        flash[:notice] = "Invalid account/password combination" 
      end
    end
  end 
#logout your User
  def  logout 
    User.logout!(session) 
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
    session.delete(:user_id)
    session.delete(:admin)
    session.delete(:registering)
    flash[:notice] = "Logged  out"
    redirect_to :action => "index", :controller => "site" 
  end 
  
  def  register 
    @title  =  "Register" 
    if  param_posted?(:user)
      @user  =  User.new(params[:user])
      @user.admin = 0
      @user.password = @user.give_encrypted(@user.password)
      if  @user.save 
        @user.login!(session) 
        
        flash[:notice] = "User #{@user.account} created!"
        session[:registering] = true
        redirect_to_create_character
      else
        @user.clear_password!
      end 
    end 
  end 

  # Redirect to the user's character (if  present). 
  def  redirect_to_create_character
     redirect_to :action  => "new", :controller => "characters" 
  end

 
  # Return true if a parameter corresponding to the given symbol was posted. 
  def param_posted?(symbol)
    request.post? and params[symbol]
  end


  # GET /news_posts/1/edit
  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    @tempuser = User.new(params[:user])
    if (params[:user][:password] != "")
      @user.update_attribute(:password, @user.give_encrypted( @tempuser.password))
      
      @user.update_attribute(:email, @tempuser.email)
        flash[:notice] = 'Account Info was successfully updated.'
    else
      
      @user.update_attribute(:email, @tempuser.email)
        flash[:notice] = 'Email was successfully updated.'
    end

        redirect_to current_character
  end
 

 
end
