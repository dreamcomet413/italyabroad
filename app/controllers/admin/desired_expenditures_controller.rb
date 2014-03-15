class Admin::DesiredExpendituresController < ApplicationController

  before_filter :admin_login_required
  layout 'admin'

  def index
    @desired_expenditures = DesiredExpenditure.all
  end

  def new
    @desired_expenditure = DesiredExpenditure.new
  end

  def edit
    @desired_expenditure = DesiredExpenditure.find(params[:id])
  end

  def create
    @desired_expenditure = DesiredExpenditure.new(params[:desired_expenditure])
    if @desired_expenditure.save
      redirect_to admin_sommeliers_url, :notice => "Successfully created desired expenditure."
    else
      render :action => 'new'
    end
  end

  def update
    @desired_expenditure = DesiredExpenditure.find(params[:id])
    if @desired_expenditure.update_attributes(params[:desired_expenditure])
      redirect_to admin_sommeliers_url, :notice  => "Successfully updated desired expenditure."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @desired_expenditure = DesiredExpenditure.find(params[:id])
    @desired_expenditure.destroy
    redirect_to admin_sommeliers_url, :notice => "Successfully destroyed desired expenditure."
  end
end
