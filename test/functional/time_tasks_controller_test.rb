require 'test_helper'

class TimeTasksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_task" do
    assert_difference('TimeTask.count') do
      post :create, :time_task => { }
    end

    assert_redirected_to time_task_path(assigns(:time_task))
  end

  test "should show time_task" do
    get :show, :id => time_tasks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => time_tasks(:one).to_param
    assert_response :success
  end

  test "should update time_task" do
    put :update, :id => time_tasks(:one).to_param, :time_task => { }
    assert_redirected_to time_task_path(assigns(:time_task))
  end

  test "should destroy time_task" do
    assert_difference('TimeTask.count', -1) do
      delete :destroy, :id => time_tasks(:one).to_param
    end

    assert_redirected_to time_tasks_path
  end
end
