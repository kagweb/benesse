# encoding: utf-8
class UploadController < ApplicationController
  before_filter :require_login

  def index
    @project = Project.find params[:project_id]
  end

  def aws

  end

  def create
    @project = Project.find params[:project_id]

    if params['upload'].blank? or params['upload']['files'].blank? or ! ['zip', 'ZIP'].include? params['upload']['files'].original_filename.split('.').last
      redirect_to project_upload_index_path @project, notice: 'ZIP 形式のファイルをアップロードしてください。'
      return
    end

    filename = Time.now.strftime("%Y%m%d%H%M%S%L") + '_' + params['upload']['files'].original_filename
    tmp_path = Rails.root.join 'tmp/upload'
    FileUtils.mkdir_p tmp_path

    fs = File.open tmp_path.join(filename), 'w'
    fs.write params['upload']['files'].read.force_encoding('UTF-8')
    fs.close

    target_path = Rails.root.join('files/upload_test').join(format "%07d", @project.id).join(format "%02d", @project.branches.last.code.to_i)
    FileUtils.rm_rf target_path if target_path.exist?
    FileUtils.mkdir_p target_path

    Zip::Archive.open(tmp_path.join(filename).to_s) do |archive|
      archive.each do |f|
        ## __MACOSX の削除
        next if f.name =~ /^__MACOSX/

        if f.directory?
          FileUtils.mkdir_p(target_path.join f.name)
        else
          # 許可されていない拡張子ファイルの削除
          next unless Benesse::Application.config.accept_extnames.include? f.name.split('.').last.split('.').last
          dirname = File.dirname(target_path.join f.name)
          FileUtils.mkdir_p dirname unless File.exist? dirname
          open(target_path.join(f.name), 'wb') do |t|
            t << f.read
          end
        end
      end
    end

    redirect_to project_upload_index_path @project
  end
end
