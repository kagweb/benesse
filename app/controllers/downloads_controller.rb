# encoding: utf-8
class DownloadsController < ApplicationController
  def index
    raise 'Token error' unless params[:token] == Benesse::Application.config.authentication_token

    project = Project.find params[:id]
    path = Benesse::Application.config.upload_dir['production'].join(format("%07d", project.id)).join(format("%02d", project.branches.last.code.to_i))

    zip = create_zip path
    File.file? zip.to_s ? send_file(zip.to_s) : redirect_to(projects_path, notice: "データのダウンロードに失敗しました。")
    return false
  end

  def get_url
    path = Benesse::Application.config.upload_root_path.join params[:path]
    raise('This file is not found.') unless File.exist? path

    if File.directory? path
      path = create_zip path

      begin
        timeout 10 do
          loop do
            break if path.exist?
          end
        end
      rescue Timeout::Error
        render json: { result: false, error: "ZIPファイルの生成に失敗しました。\nフォルダのサイズが大きすぎる可能性があります。" }
        return false;
      end

      filename = path.to_s.split('/').last
      type = 'dir'
    else
      filename = params[:path]
      type = 'file'
    end

    render json: { result: File.exist?(path), url: downloads_url(f: filename, type: type) }
  end

  def optional
    if params[:type] == 'file'
      path = Benesse::Application.config.upload_root_path.join params[:f]
    else
      path = Benesse::Application.config.upload_tmp_path.join params[:f]
    end

    send_file path
  end
end
