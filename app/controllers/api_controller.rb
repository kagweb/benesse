class ApiController < ApplicationController
  def user_list
    unless request.xhr?
      render :nothing => true, :status => 404
      return;
    end

    if params[:department].empty?
      users = User.all
    else
      department = Department.find params[:department]
      users = User.find :all, conditions: { department_id: department.id }
    end

    unless users
      render :nothing => true, :status => 404
      return;
    end

    render json: users.to_json
  end
end
