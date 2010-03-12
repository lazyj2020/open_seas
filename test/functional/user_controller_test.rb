require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

class UserControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :users
  
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
 
    @valid_user = users(:valid_user)
  end

  def test_registration_page 
    get :register 
    title = assigns(:title) 
    assert_equal "Register", title 
    assert_response :success 
    assert_template "register" 
    

    assert_tag "form", :attributes => { :action => "/user/register",
                                        :method => "post"  } 
    assert_tag "input", :attributes => { :name => "user[account]", 
                                          :type => "text",  
                                          :size => User::ACCOUNT_SIZE, 
                                          :maxlength => User::ACCOUNT_MAX_LENGTH } 
    assert_tag "input", :attributes => { :name => "user[email]", 
                                              :type  =>  "text", 
                                :size  =>  User::EMAIL_SIZE, 
                                :maxlength => User::EMAIL_MAX_LENGTH } 
    assert_tag "input", :attributes => { :name => "user[password]", 
                                :type => "password", 
                                :size =>User::PASSWORD_SIZE, 
                                :maxlength =>  User::PASSWORD_MAX_LENGTH } 
    assert_tag "input", :attributes => { :type => "submit", 
                                        :value  =>  "Register!" } 
   end 
   

  def  test_registration_success 
    post  :register, :user => { :account => "new_account", 
                              :email => "valid@example.com", 
                              :password => "long_enough_password" } 
 
    user = assigns(:user) 
    assert_not_nil user 
 
    new_user = User.find_by_account_and_password(user.account,user.password) 
    assert_equal new_user, user 
 
    assert_equal "User #{new_user.account} created!", flash[:notice] 
    assert_redirected_to :controller => "characters", :action => "new" 
  end 

 
  def  test_registration_failure 
    post :register, :user => { :account => "tes/gtga", 
                               :email => "test@tt.tt", 
                               :password => "ttt" } 
    assert_response :success 
    assert_template "register" 

 
    assert_tag "div", :attributes => { :id => "errorExplanation", 
                                       :class => "errorExplanation" } 
 
  assert_tag   "li",  :content   => /Account/ 
  assert_tag   "li",  :content   => /Password/ 

 
    error_div = { :tag => "div", :attributes => { :class => "fieldWithErrors" } } 


    assert_tag "input", 
               :attributes => { :name => "user[account]", 
                                 :value => "tes/gtga" }, 
               :parent => error_div 

    assert_tag "input", 
               :attributes => { :name => "user[password]", 
                                 :value => nil }, 
               :parent => error_div 
               
  end 
  def test_login_page
    get :login
    title = assigns(:title)
    assert_equal "Log in to Open Seas", title
    assert_response :success
    assert_template "login"
    assert_tag "form", :attributes => { :action => "/user/login", 
                                        :method => "post" }
    assert_tag "input",
               :attributes => { :name => "user[account]",
                                :type => "text", 
                                :size => User::ACCOUNT_SIZE,
                                :maxlength => User::ACCOUNT_MAX_LENGTH }
    assert_tag "input", :attributes => { :name => "user[remember_me]",
                                         :type => "checkbox" }
    assert_tag "input", :attributes => { :type => "submit",
                                         :value => "Login!" }     
  end
  
 


end 