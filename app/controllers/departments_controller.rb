class DepartmentsController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def index
    @departments = Department.all
  end

  def show
    @department = Department.find params[:id]
  end

  def new
    @department = Department.new
  end

  def edit
    @department = Department.find params[:id]
  end

  def create
    @department = Department.new params[:department]
    if @department.save
      redirect_to @department, notice: 'Department was successfully created.'
    else
      render :new
    end
  end

  def update
    @department = Department.find params[:id]
    if @department.update_attributes params[:department]
      redirect_to @department, notice: 'Department was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @department = Department.find params[:id]
    @department.destroy
    redirect_to departments_url
  end
end
