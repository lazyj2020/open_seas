require 'test_helper'

class ShipAttributesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ship_attributes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ship_attribute" do
    assert_difference('ShipAttribute.count') do
      post :create, :ship_attribute => { }
    end

    assert_redirected_to ship_attribute_path(assigns(:ship_attribute))
  end

  test "should show ship_attribute" do
    get :show, :id => ship_attributes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ship_attributes(:one).to_param
    assert_response :success
  end

  test "should update ship_attribute" do
    put :update, :id => ship_attributes(:one).to_param, :ship_attribute => { }
    assert_redirected_to ship_attribute_path(assigns(:ship_attribute))
  end

  test "should destroy ship_attribute" do
    assert_difference('ShipAttribute.count', -1) do
      delete :destroy, :id => ship_attributes(:one).to_param
    end

    assert_redirected_to ship_attributes_path
  end
end
