require 'test_helper'

class BattlesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:battles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create battle" do
    assert_difference('Battle.count') do
      post :create, :battle => { }
    end

    assert_redirected_to battle_path(assigns(:battle))
  end

  test "should show battle" do
    get :show, :id => battles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => battles(:one).to_param
    assert_response :success
  end

  test "should update battle" do
    put :update, :id => battles(:one).to_param, :battle => { }
    assert_redirected_to battle_path(assigns(:battle))
  end

  test "should destroy battle" do
    assert_difference('Battle.count', -1) do
      delete :destroy, :id => battles(:one).to_param
    end

    assert_redirected_to battles_path
  end
end
