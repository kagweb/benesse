class ProjectsController < ApplicationController
  before_filter :require_login, except: :index

  def index
    redirect_to login_url unless current_user
    @date = params[:date] ? Date.strptime(params[:date]) : Date.new(Time.now.year, Time.now.month, 1)
    @projects = Project.find :all, conditions: ['created_at >= ? and created_at < ?', @date, @date >> 1]
  end

  def show
    @project = Project.find params[:id]
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find params[:id]
  end

  def create
    @project = Project.new params[:project]
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    @project = Project.find params[:id]
    if @project.update_attributes params[:project]
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find params[:id]
    @project.destroy
    redirect_to projects_url
  end

  def authors
    @project = Project.find params[:id]
  end

  def check
    @project = Project.find params[:id]

    case
      when params[:type] == 'test'
        status = 1
      when params[:type] == 'production'
        status = 2
      else
        status = 0
    end

    @comments = @project.comments.find :all, conditions: [ "status = ?", status ]
  end

end
