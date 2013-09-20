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
      redirect_to aws_path, alert: alert
      return false
    end

    if params[:download] == 'on'
      send_file(FileTest.directory?(@path) ? _create_zip(@path) : @path)
    elsif params[:upload] == 'on'
      @path = Pathname.new(File.dirname @path) if File.file? @path
      upload
      redirect_to aws_path, notice: 'アップロードに成功しました。'
    elsif params[:delete] == 'on'
      FileUtils.rm_rf @path
      redirect_to aws_path, notice: 'ファイルの削除に成功しました。'
    else
      redirect_to aws_path, alert: "ファイルの操作に失敗しました。"
    end

    return false
  end

  private

  def upload
    unless params[:upload_file].original_filename.split(/\./).last == 'zip'
      open(@path.join(filename), 'wb') {|t| t << params[:upload_file].read }
      return
    end

    _unzip(params[:upload_file], @path)
  end
end
