# encoding: utf-8
class CloseOutsController < ApplicationController
  before_filter :check_token

  def test
    project = Project.find params[:id]
    project.status = 4 if project.status == 3
    render json: { result: project.save }
  end

  def production
    project = Project.find params[:id]
    project.status = 6 if project.status == 5
    render json: { result: project.save }
  end

  private

  def check_token
    render json: { result: false } and return unless params[:token] == Benesse::Application.config.authentication_token
  end
end
