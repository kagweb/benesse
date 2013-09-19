# encoding: utf-8
class ApiController < ApplicationController
  def user_list
    render json: params[:department].blank? ? User.where(['department_id != ?', _department_id]) : User.where(department_id: _department_id)
  end

  private

  def _department_id
    return params[:department].presence || Department.find_by_name('業者').id
  end
end
