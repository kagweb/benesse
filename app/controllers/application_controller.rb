# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def is_promotion_department?
    current_user && current_user.is_promotion_department?
  end

  def promotion_department_required
    redirect_to root_url, alert: '管理者権限が必要です' unless is_promotion_department?
  end

  def is_supplier_department?
    current_user && current_user.is_supplier_department?
  end

  def supplier_department_except
    return unless is_supplier_department?
    logout
    redirect_to root_url, alert: 'アクセス権がありません。'
  end
end
