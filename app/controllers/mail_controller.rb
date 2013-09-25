# encoding: UTF-8
class MailController < ApplicationController
  before_filter :require_login

  def remind
    project = Project.find params[:id]
    to = User.where(['id IN (?)', params[:to].try(:keys)]).pluck :email
    cc = User.where(['id IN (?)', params[:cc].try(:keys)]).pluck :email
    mail = UserMailer.remind_email to, cc, params[:mail_text], project
    mail.transport_encoding = '8bit'
    mail.deliver
    redirect_to project, notice: 'リマインドメールを送信しました。'
  end
  
  def confirmation_request
  end
end
