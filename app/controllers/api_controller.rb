class ApiController < ApplicationController
  def user_list
    render json: params[:department].empty? ? User.all : Department.find(params[:department]).try(:users)
  end
end
