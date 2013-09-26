# encoding: utf-8
class ApiController < ApplicationController
  def user_list
    render json: params[:department].blank? ? User.where(['department_id != ?', _department_id]) : User.where(department_id: _department_id)
  end

  def projects
    render json: { result: false } and return unless params[:token] == Benesse::Application.config.authentication_token
    target_day = Date.today - 1.day
    @projects = Project.where{ ((test_upload_at >= target_day) & (test_upload_at < target_day + 1) | (production_upload_at >= target_day) & (production_upload_at < target_day)) }.where(registration_status: true)
    response = Hash[ result: true, projects: Array.new ]
    @projects.each { |project| response[:projects].push project.to_api if project.to_api }
    render json: response
  end

  private

  def _department_id
    return params[:department].presence || Department.find_by_name('業者').id
  end
end
