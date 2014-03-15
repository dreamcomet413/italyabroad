require 'test_helper'

class DesiredExpendituresControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    DesiredExpenditure.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    DesiredExpenditure.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to desired_expenditures_url
  end

  def test_update_invalid
    DesiredExpenditure.any_instance.stubs(:valid?).returns(false)
    put :update, :id => DesiredExpenditure.first
    assert_template 'edit'
  end

  def test_update_valid
    DesiredExpenditure.any_instance.stubs(:valid?).returns(true)
    put :update, :id => DesiredExpenditure.first
    assert_redirected_to desired_expenditures_url
  end

  def test_destroy
    desired_expenditure = DesiredExpenditure.first
    delete :destroy, :id => desired_expenditure
    assert_redirected_to desired_expenditures_url
    assert !DesiredExpenditure.exists?(desired_expenditure.id)
  end
end
