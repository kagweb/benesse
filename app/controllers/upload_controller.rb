# encoding: utf-8
class UploadController < ApplicationController
  before_filter :require_login

  def index
    @project = Project.find params[:project_id]
  end

  def create
    @project = Project.find params[:project_id]

    # ファイルが指定されていない時と、指定されたファイルの拡張子が zip でない時
    if params['upload'].blank? or params['upload']['files'].blank? or ! ['zip', 'ZIP'].include? params['upload']['files'].original_filename.split('.').last
      redirect_to project_upload_index_path(@project), alert: 'ZIP 形式のファイルをアップロードしてください。'
      return
    end

    tmp_file = create_tmp_file(params['upload']['files'])
    upload_files tmp_file, 'production'
    upload_files tmp_file, 'test' if @project.exists_test_server
    remove_tmp_file tmp_file

    redirect_to project_upload_index_url(@project), notice: "#{params['upload']['files'].original_filename} のアップロードに成功しました。"
  end

  private

  def upload_files(file, env)
    # 展開するディレクトリを指定
    target_path = Benesse::Application.config.upload_dir[env].join(format "%07d", @project.id).join(format "%02d", @project.branches.last.code.to_i)

    # もし同一ブランチにアップロードされたデータがあれば、全て削除し、新しくディレクトリを作成
    FileUtils.rm_rf target_path if target_path.exist?
    FileUtils.mkdir_p target_path

    # zip を展開
    unzip(file, target_path)
  end
end
