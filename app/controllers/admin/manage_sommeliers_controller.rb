class Admin::ManageSommeliersController < ApplicationController

  before_filter :admin_login_required
  layout 'admin'

  def index
    @wine_sizes = WineSize.all
    @food_or_drinks = FoodOrDrink.all
    @desired_expenditures = DesiredExpenditure.all
    @food_options = FoodOption.all
  end

  def create

  end
end
