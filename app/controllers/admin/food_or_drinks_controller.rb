class Admin::FoodOrDrinksController < ApplicationController
  before_filter :admin_login_required
  layout 'admin'
  def index
    @food_or_drinks = FoodOrDrink.all
  end

  def show
    @food_or_drink = FoodOrDrink.find(params[:id])
  end

  def new
    @food_or_drink = FoodOrDrink.new
  end

  def create
    @food_or_drink = FoodOrDrink.new(params[:food_or_drink])
    if @food_or_drink.save
      redirect_to admin_sommeliers_path, :notice => "Successfully created food or drink."
    else
      render :action => 'new'
    end
  end

  def edit
    @food_or_drink = FoodOrDrink.find(params[:id])
  end

  def update
    @food_or_drink = FoodOrDrink.find(params[:id])
    if @food_or_drink.update_attributes(params[:food_or_drink])
      redirect_to admin_sommeliers_path, :notice  => "Successfully updated food or drink."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @food_or_drink = FoodOrDrink.find(params[:id])
    @food_or_drink.destroy
    redirect_to admin_sommeliers_path, :notice => "Successfully destroyed food or drink."
  end
end
