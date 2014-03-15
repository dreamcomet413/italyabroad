require 'test_helper'

class FoodOptionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    FoodOption.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    FoodOption.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to food_options_url
  end

  def test_edit
    get :edit, :id => FoodOption.first
    assert_template 'edit'
  end

  def test_update_invalid
    FoodOption.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FoodOption.first
    assert_template 'edit'
  end

  def test_update_valid
    FoodOption.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FoodOption.first
    assert_redirected_to food_options_url
  end

  def test_destroy
    food_option = FoodOption.first
    delete :destroy, :id => food_option
    assert_redirected_to food_options_url
    assert !FoodOption.exists?(food_option.id)
  end
end
