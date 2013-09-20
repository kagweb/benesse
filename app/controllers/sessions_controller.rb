# coding: utf-8
class SessionsController < ApplicationController
  before_filter :require_login, only: :destroy
  skip_after_filter :set_return_to_url

  def new
    redirect_to root_url if current_user
  end

  def create
    if @user = login(params[:username], params[:password], true)
      redirect_back_or_to root_url, notice: "ようこそ#{@user.name}さん。"
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
