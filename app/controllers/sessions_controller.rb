# coding: utf-8
class SessionsController < ApplicationController
  before_filter :require_login, only: :destroy

  def new
    redirect_to root_url if current_user
  end

  def create
    if @user = login(params[:username], params[:password], true)
      redirect_back_or_to root_url, notice: "ようこそ#{@user.username}さん。"
    else
      flash.now[:alert] = 'ユーザーIDかパスワードが違います。'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: 'ログアウトしました。'
  end
end
