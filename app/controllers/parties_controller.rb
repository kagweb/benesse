class PartiesController < ApplicationController
  before_filter :require_login

  def index
    @parties = Party.all
  end

  def show
    @party = Party.find params[:id]
  end

  def new
    @party = Party.new
  end

  def edit
    @party = Party.find params[:id]
  end

  def create
    @party = Party.new required: params[:party][:required]
    @party.project = Project.find params[:party][:project_id]
    @party.user = User.find params[:party][:user]
    
    if @party.save
      redirect_to @party, notice: 'Party was successfully created.'
    else
      render :new
    end
  end

  def update
    @party = Party.find params[:id]
    if @party.update_attributes params[:party]
      redirect_to @party, notice: 'Party was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @party = Party.find params[:id]
    @party.destroy
    project = Project.find params[:project_id]
    redirect_to project
  end
end
