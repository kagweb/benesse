# encoding: utf-8
class DownloadsController < ApplicationController
  def index
    raise 'Token error' unless params[:token] == Benesse::Application.config.authentication_token

    project = Project.find params[:id]
    path = Benesse::Application.config.upload_dir['production'].join(format("%07d", project.id)).join(format("%02d", project.branches.last.code.to_i))

    zip = _create_zip path
    File.file? zip.to_s ? send_file(zip.to_s) : redirect_to(projects_path, notice: "データのダウンロードに失敗しました。")
    return false
  end
end
