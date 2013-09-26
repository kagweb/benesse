# encoding: UTF-8
class MailController < ApplicationController
  before_filter :require_login

  def remind
    project = Project.find params[:id]
    to = User.where(['id IN (?)', params[:to].try(:keys)]).pluck :email
    cc = User.where(['id IN (?)', params[:cc].try(:keys)]).pluck :email

    unless to.present?
      redirect_to project, alert: 'TOが選択されていません。'
      return false
    end

    unless params[:mail_text].present?
      redirect_to project, alert: 'メール本文が入力されていません。'
      return false
    end

    mail = UserMailer.remind_email to, cc, params[:mail_text], project
    mail.transport_encoding = '8bit'
    mail.deliver
    redirect_to project, notice: 'リマインドメールを送信しました。'
  end
end
