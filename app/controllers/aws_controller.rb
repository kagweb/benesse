# encoding: UTF-8
class AwsController < ApplicationController
  before_filter :require_login

  def index
    
  end

  def actions
    alert = nil
    alert = "指定されたパスが不正です。" if params[:path].blank?

    @path = Benesse::Application.config.upload_root_path.join params[:path]
    alert = "指定されたファイルが存在しません。" unless FileTest.exist? @path
    alert = "アップロードするファイルが添付されていません。" if params[:upload] == 'on' and params[:upload_file].blank?

    if alert
      redirect_to return_to_url, alert: alert
      return false
    end

    if params[:download] == 'on'
      if FileTest.directory?(@path)
        @path = create_zip(@path)
        send_file @path
        # remove_tmp_file @path
      else
        send_file @path
      end
    elsif params[:upload] == 'on'
      @path = Pathname.new(File.dirname @path) if File.file? @path
      upload
      redirect_to return_to_url, notice: 'アップロードに成功しました。'
    elsif params[:delete] == 'on'
      FileUtils.rm_rf @path
      redirect_to return_to_url, notice: 'ファイルの削除に成功しました。'
    else
      redirect_to return_to_url, alert: "ファイルの操作に失敗しました。"
    end

    return false
  end

  private

  def upload
    unless params[:upload_file].original_filename.split(/\./).last == 'zip'
      open(@path.join(params[:upload_file].original_filename), 'wb') {|t| t << params[:upload_file].read }
      return
    end

    tmp_file  = create_tmp_file(params[:upload_file])
    unzip(tmp_file, @path)
    remove_tmp_file tmp_file
  end
end
