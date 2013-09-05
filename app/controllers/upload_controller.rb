class UploadController < ApplicationController
  def index
    @project = Project.find params[:project_id]
  end

  def aws

  end
end
