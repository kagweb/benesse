# encoding: UTF-8
class MailController < ApplicationController
  before_filter :require_login

  def remind
    project = Project.find params[:id]
    to = User.where(['id IN (?)', params[:to].try(:keys)]).pluck :email
    cc = User.where(['id IN (?)', params[:cc].try(:keys)]).pluck :email
    text = params[:mail_text]

    pp to
    pp cc
    pp text

    redirect_to project, notice: 'リマインドメールを送信しました。'
  end
  
  def confirmation_request
  end
end
