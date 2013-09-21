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
end
