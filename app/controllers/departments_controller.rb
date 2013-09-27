# encoding: UTF-8
class DepartmentsController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def index
    @departments = Department.all
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
      redirect_to projects_path, notice: '部署を新しく登録しました。'
    else
      render :new
    end
  end

  def update
    @department = Department.find params[:id]
    if @department.update_attributes params[:department]
      redirect_to departments_url, notice: '部署の更新に成功しました。'
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
