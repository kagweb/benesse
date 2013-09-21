# encoding: utf-8
class CloseOutsController < ApplicationController
  before_filter :check_token

  def test
    project = Project.find params[:id]
    project.status = 4 if project.status == 3
    render json: project.save
  end

  def production
    project = Project.find params[:id]
    project.status = 6 if project.status == 5
    render json: project.save
  end

  private

  def check_token
    raise 'Token error' unless params[:token] == Benesse::Application.config.authentication_token
  end

end
