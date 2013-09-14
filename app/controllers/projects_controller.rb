class ProjectsController < ApplicationController
  before_filter :require_login, except: :index

  def index
    redirect_to login_url unless current_user

    @date = params[:date] ? Date.strptime(params[:date]) : Date.new(Time.now.year, Time.now.month, 1)

    if params[:server] and ! params[:server].empty?
      @projects = Project.where ['created_at >= ? and created_at < ? and upload_server = ?', @date, @date >> 1, params[:server]]
    else
      @projects = Project.where ['created_at >= ? and created_at < ?', @date, @date >> 1]
    end
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
    users = [ params[:project][:authorizer], params[:project][:promoter], params[:project][:operator] ]
    ['authorizer', 'promoter', 'operator'].each {|u| params[:project].delete u }

    @project = Project.new params[:project]
    User.where(['id IN (?)',users]).each do |user|
      @project.authorizer = user if user.id == users[0].to_i
      @project.promoter   = user if user.id == users[1].to_i
      @project.operator   = user if user.id == users[2].to_i
    end

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    operator = User.find params[:project][:operator]
    params[:project].delete 'operator'
    @project = Project.find params[:id]
    @project.attributes = params[:project]
    @project.operator = operator

    if @project.save
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

  def author_update
    @project = Project.find params[:id]
    @project.authorizer = User.find params[:project][:authorizer]
    @project.promoter   = User.find params[:project][:promoter]
    @project.save ? redirect_to(@project, notice: 'Updated authors') : render(:authors)
  end

  def check
    @project = Project.find params[:id]
    @status = _status_code params[:status]

    if request.post? and ! params[:confirmation].blank?
      Confirmation.delete_all project_id: @project.id, user_id: current_user.id, status: @status 
      @confirmation = @project.confirmations.new response: params[:confirmation][:response], status: @status
      @confirmation.user = current_user
      flash[:notice] = "Confirmation was successfully created." if @confirmation.save
    end

    @comment = Comment.new status: @status
    @comment.project = @project
    @comment.user = current_user
    @comments = @project.comments.where status: @status
  end

  def comment
    @comment = Comment.new status: params[:comment][:status], comment: params[:comment][:comment]
    @comment.project = Project.find params[:id]
    @comment.user = current_user

    status = _status_slug params[:comment][:status].to_i

    if @comment.save
      redirect_to "/projects/#{params[:id]}/check/#{status}", notice: 'Comment was successfully created.'
    else
      redirect_to "/projects/#{params[:id]}/check/#{status}"
    end
  end

  def update_branch
    project = Project.find params[:id]
    project.update_branch
    redirect_to project
  end

  def confirm
    project = Project.find params[:id]

    unless current_user.id == project.authorizer_id
      redirect_to project
      return
    end

    project.confirmed = true
    project.save
    redirect_to project, notice: 'Confirm this project.'
  end

  def remind_mail
    project = Project.find params[:id]
    pp params[:to] # TOに付けるユーザの ID 一覧
    pp params[:cc] # CCに付けるユーザの ID 一覧
    pp params[:mail_text] # メール本文
    redirect_to project
  end

  private

  def _status_slug(code)
    return code if ['html', 'test', 'production'].include? code
    status = { 0 => 'html', 1 => 'test', 2 => 'production' }
    return status[code.to_i]
  end

  def _status_code(slug)
    return slug if [0..2].include? slug
    status = { 'html' => 0, 'test' => 1, 'production' => 2 }
    return status[slug]
  end
end
