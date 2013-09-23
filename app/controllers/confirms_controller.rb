# encoding: UTF-8
class ConfirmsController < ApplicationController
  before_filter :require_login
  before_filter :supplier_department_except

  def authority
    project = Project.find params[:id]
    project.old_authorizer = nil if params[:auth] == 'authorizer'
    project.old_promoter   = nil if params[:auth] == 'promoter'
    project.save

    redirect_to project
  end

  def update_branch
    project = Project.find params[:id]
    project.update_branch
    redirect_to project
  end

  def project
    project = Project.find params[:id]
    project.confirmed = true
    project.status = 1
    project.save
    redirect_to project, notice: "#{project.name} が承認されました。"
  end

  def aws
    project = Project.find params[:id]
    project.status = 2
    project.save
    redirect_to project, notice: '納品データが承認されました。'
  end
end
