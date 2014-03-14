require 'test_helper'

class Admin::WineSizesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Admin::WineSize.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Admin::WineSize.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to admin_wine_sizes_url
  end

  def test_edit
    get :edit, :id => Admin::WineSize.first
    assert_template 'edit'
  end

  def test_update_invalid
    Admin::WineSize.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Admin::WineSize.first
    assert_template 'edit'
  end

  def test_update_valid
    Admin::WineSize.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Admin::WineSize.first
    assert_redirected_to admin_wine_sizes_url
  end

  def test_destroy
    wine_size = Admin::WineSize.first
    delete :destroy, :id => wine_size
    assert_redirected_to admin_wine_sizes_url
    assert !Admin::WineSize.exists?(wine_size.id)
  end
end
