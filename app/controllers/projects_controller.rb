# encoding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_login, except: :index
  before_filter :supplier_department_except

  def index
    redirect_to login_url unless current_user

    @date = params[:date] ? Date.strptime(params[:date]) : Date.new(Time.now.year, Time.now.month, 1)

    if params[:server] and ! params[:server].empty?
      @projects = Project.where(['production_upload_at >= ? and production_upload_at < ? and upload_server = ?', @date, @date >> 1, params[:server]]).order('production_upload_at')
    else
      @projects = Project.where(['production_upload_at >= ? and production_upload_at < ?', @date, @date >> 1]).order('production_upload_at')
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

    @project.save ? redirect_to(@project, notice: "移送案件[ #{@project.name} ]の新規登録しました。") : render(:new)
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

    @project.save ? redirect_to(@project, notice: '付け替えが完了しました。') : render(:authors)
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
      redirect_to "/projects/#{params[:id]}/check/#{status}", notice: 'コメントを追加しました。'
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
    project.confirmed = true
    project.status = 1
    project.save
    redirect_to project, notice: "#{project.name} が承認されました。"
  end

  def confirm_html
    project = Project.find params[:id]
    project.status = 2
    project.save
    redirect_to project, notice: '納品データが承認されました。'
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
