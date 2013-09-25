# encoding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_login, except: :index
  before_filter :supplier_department_except, except: :upload

  def index
    redirect_to login_url unless current_user
    @search = Project.order('register_datetime ASC, production_upload_at ASC').search(params[:q])
    @projects = @search.result
    closed_projects = []
    @projects.each_with_index {|project, i| closed_projects << @projects.delete_at(i) if project.status == 7 }
    @projects += closed_projects
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
      mail = UserMailer.require_confirm_email @project
      mail.transport_encoding = '8bit'
      mail.deliver

      redirect_to @project, notice: "移送案件[ #{@project.name} ]の新規登録しました。"
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
    @project.branches.where(code: '90').first_or_create if @project.miss

    if @project.save
      redirect_to @project, notice: "#{@project.name} を編集しました。"
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

    if params[:project][:authorizer]
      user = User.find params[:project][:authorizer]
      unless @project.authorizer == user
        @project.old_authorizer = @project.authorizer
        @project.authorizer = user
      end
    end

    if params[:project][:promoter]
      user = User.find params[:project][:promoter]
      unless @project.promoter == user
        @project.old_promoter = @project.promoter
        @project.promoter = user
      end
    end

    if @project.save
      mail = UserMailer.changed_authorities_email @project
      mail.transport_encoding = '8bit'
      mail.deliver

      redirect_to @project, notice: '付替えが完了しました。'
    else
      render :authors
    end
  end

  def check
    @project = Project.find params[:id]
    @status = _status_code params[:status]
    @comment = Comment.new status: @status
    @comment.project = @project
    @comment.user = current_user
    @comments = @project.comments.where status: @status
  end

  def check_confirmation
    @project = Project.find params[:id]
    @status = _status_code params[:status]
    Confirmation.delete_all project_id: @project.id, user_id: current_user.id, status: @status
    @confirmation = @project.confirmations.new response: params[:confirmation][:response], status: @status
    @confirmation.user = current_user

    if @confirmation.save
      redirect_to @project, notice: "#{t('view.project.' + params[:status])} の進捗状況を更新しました。"
    else
      redirect_to @project, url: { action: :check, status: params[:status] }, notice: "#{t('view.project.' + params[:status])} の進捗状況を更新に失敗しました。"
    end
  end

  def comment
    @comment = Comment.new status: params[:comment][:status], comment: params[:comment][:comment]
    @comment.project = Project.find params[:id]
    @comment.user = current_user

    status = _status_slug params[:comment][:status].to_i

    if @comment.save
      redirect_to check_project_url(status: status), notice: 'コメントを投稿しました。'
    else
      redirect_to check_project_url(status: status), alert: 'コメントの投稿に失敗しました。'
    end
  end

  private

  def _status_slug(code)
    return code if ['aws', 'test', 'production'].include? code
    status = { 0 => 'aws', 1 => 'test', 2 => 'production' }
    return status[code.to_i] || 'aws'
  end

  def _status_code(slug)
    return slug if [0..2].include? slug
    status = { 'aws' => 0, 'test' => 1, 'production' => 2 }
    return status[slug]
  end
end
