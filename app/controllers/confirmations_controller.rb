class ConfirmationsController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def index
    @confirmations = Confirmation.all
  end

  def show
    @confirmation = Confirmation.find params[:id]
  end

  def new
    @confirmation = Confirmation.new
  end

  def edit
    @confirmation = Confirmation.find params[:id]
  end

  def create
    @confirmation = Confirmation.new params[:confirmation]
    if @confirmation.save
      redirect_to @confirmation, notice: 'Confirmation was successfully created.'
    else
      render :new
    end
  end

  def update
    @confirmation = Confirmation.find params[:id]
    if @confirmation.update_attributes params[:confirmation]
      redirect_to @confirmation, notice: 'Confirmation was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @confirmation = Confirmation.find params[:id]
    @confirmation.destroy
    redirect_to confirmations_url
  end
end
