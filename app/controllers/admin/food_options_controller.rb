class Admin::FoodOptionsController < ApplicationController
  before_filter :admin_login_required
  layout 'admin'

  def index
    @food_options = FoodOption.all
  end

  def new
    @food_option = FoodOption.new
  end

  def create
    @food_option = FoodOption.new(params[:food_option])
    if @food_option.save
      redirect_to admin_sommeliers_path, :notice => "Successfully created food option."
    else
      render :action => 'new'
    end
  end

  def edit
    @food_option = FoodOption.find(params[:id])
  end

  def update
    @food_option = FoodOption.find(params[:id])
    if @food_option.update_attributes(params[:food_option])
      redirect_to admin_sommeliers_path, :notice  => "Successfully updated food option."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @food_option = FoodOption.find(params[:id])
    @food_option.destroy
    redirect_to admin_sommeliers_path, :notice => "Successfully destroyed food option."
  end
end
