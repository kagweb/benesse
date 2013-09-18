class BranchesController < ApplicationController
  before_filter :require_login

  def index
    @branches = Branch.all
  end

  def show
    @branch = Branch.find params[:id]
  end

  def new
    @branch = Branch.new
  end

  def edit
    @branch = Branch.find params[:id]
  end

  def create
    @branch = Branch.new params[:branch]
    if @branch.save
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      render :new
    end
  end

  def update
    @branch = Branch.find params[:id]
    if @branch.update_attributes params[:branch]
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @branch = Branch.find params[:id]
    @branch.destroy
    redirect_to branches_url
  end
end
