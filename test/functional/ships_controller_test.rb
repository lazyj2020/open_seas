require 'test_helper'

class ShipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ship" do
    assert_difference('Ship.count') do
      post :create, :ship => { }
    end

    assert_redirected_to ship_path(assigns(:ship))
  end

  test "should show ship" do
    get :show, :id => ships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ships(:one).to_param
    assert_response :success
  end

  test "should update ship" do
    put :update, :id => ships(:one).to_param, :ship => { }
    assert_redirected_to ship_path(assigns(:ship))
  end

  test "should destroy ship" do
    assert_difference('Ship.count', -1) do
      delete :destroy, :id => ships(:one).to_param
    end

    assert_redirected_to ships_path
  end
end
