require File.dirname(__FILE__) + '/../test_helper'
require   'site_controller' 

#  Re-raise   errors   caught  by  the  controller. 
class SiteControllerTest < ActionController::TestCase

  def test_index 
    get :index 
    title = assigns(:title) 
    assert_equal "Welcome to the Open Seas", title 
    assert_response :success 
    assert_template "index" 
  end 

  def test_about 
    get :about 
    title = assigns(:title) 
    assert_equal "About the Open Seas", title 
    assert_response :success 
    assert_template "about" 
  end 

  def test_help 
    get :help 
    title  =  assigns(:title) 
    assert_equal "Help",  title 
    assert_response :success 
    assert_template "help" 
  end 
end 
