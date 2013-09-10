require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authentications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authentication" do
    assert_difference('Authentication.count') do
      post :create, :authentication => { }
    end

    assert_redirected_to authentication_path(assigns(:authentication))
  end

  test "should show authentication" do
    get :show, :id => authentications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => authentications(:one).to_param
    assert_response :success
  end

  test "should update authentication" do
    put :update, :id => authentications(:one).to_param, :authentication => { }
    assert_redirected_to authentication_path(assigns(:authentication))
  end

  test "should destroy authentication" do
    assert_difference('Authentication.count', -1) do
      delete :destroy, :id => authentications(:one).to_param
    end

    assert_redirected_to authentications_path
  end
end
