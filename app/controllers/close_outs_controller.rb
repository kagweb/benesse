# encoding: utf-8
class CloseOutsController < ApplicationController
  before_filter :check_token

  def test
    @project = Project.find params[:id]
    @project.status = 4 if project.status == 3
    @project.save
    mail = UserMailer.test_require_confirm_email project
    mail.transport_encoding = '8bit'
    mail.deliver
    render json: { result: true }
  end

  def production
    @project = Project.find params[:id]
    @project.status = 6 if project.status == 5
    @project.save
    mail = UserMailer.production_require_confirm_email project
    mail.transport_encoding = '8bit'
    mail.deliver
    render json: { result: true }
  end

  private

  def check_token
    render json: { result: false } and return unless params[:token] == Benesse::Application.config.authentication_token
  end
end
