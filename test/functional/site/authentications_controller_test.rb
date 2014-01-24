require 'test_helper'

class Site::AuthenticationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_create_invalid
    Site::Authentication.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Site::Authentication.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to site_authentications_url
  end

  def test_destroy
    authentication = Site::Authentication.first
    delete :destroy, :id => authentication
    assert_redirected_to site_authentications_url
    assert !Site::Authentication.exists?(authentication.id)
  end
end
