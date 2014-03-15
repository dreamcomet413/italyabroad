require 'test_helper'

class FoodOrDrinksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => FoodOrDrink.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    FoodOrDrink.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    FoodOrDrink.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to food_or_drink_url(assigns(:food_or_drink))
  end

  def test_edit
    get :edit, :id => FoodOrDrink.first
    assert_template 'edit'
  end

  def test_update_invalid
    FoodOrDrink.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FoodOrDrink.first
    assert_template 'edit'
  end

  def test_update_valid
    FoodOrDrink.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FoodOrDrink.first
    assert_redirected_to food_or_drink_url(assigns(:food_or_drink))
  end

  def test_destroy
    food_or_drink = FoodOrDrink.first
    delete :destroy, :id => food_or_drink
    assert_redirected_to food_or_drinks_url
    assert !FoodOrDrink.exists?(food_or_drink.id)
  end
end
