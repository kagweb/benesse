# encoding: utf-8
class UploadController < ApplicationController
  before_filter :require_login

  def index
    @project = Project.find params[:project_id]
  end

  def aws
    supplier_department_except
  end

  def create
    @project = Project.find params[:project_id]

    # ファイルが指定されていない時と、指定されたファイルの拡張子が zip でない時
    if params['upload'].blank? or params['upload']['files'].blank? or ! ['zip', 'ZIP'].include? params['upload']['files'].original_filename.split('.').last
      redirect_to project_upload_index_path @project, notice: 'ZIP 形式のファイルをアップロードしてください。'
      return
    end

    # /tmp/upload に POST された zip ファイルを一時的に保存
    filename = Time.now.strftime("%Y%m%d%H%M%S%L") + '_' + params['upload']['files'].original_filename
    tmp_path = Benesse::Application.config.upload_tmp_path
    FileUtils.mkdir_p tmp_path
    fs = File.open tmp_path.join(filename), 'w'
    fs.write params['upload']['files'].read.force_encoding('UTF-8')
    fs.close

    # 展開するディレクトリを指定
    target_path = Benesse::Application.config.upload_dir['production'].join(format "%07d", @project.id).join(format "%02d", @project.branches.last.code.to_i)

    # もし同一ブランチにアップロードされたデータがあれば、全て削除し、新しくディレクトリを作成
    FileUtils.rm_rf target_path if target_path.exist?
    FileUtils.mkdir_p target_path

    # zip を作成
    Zip::Archive.open tmp_path.join(filename).to_s do |archive|
      archive.each do |f|
        ## __MACOSX の削除
        next if f.name =~ /^__MACOSX/

        if f.directory?
          FileUtils.mkdir_p(target_path.join f.name)
          next
        end

        # 許可されていない拡張子ファイルの場合、スキップする
        next unless Benesse::Application.config.accept_extnames.include? f.name.split('.').last.split('.').last
        dirname = File.dirname(target_path.join f.name)
        FileUtils.mkdir_p dirname unless File.exist? dirname
        open(target_path.join(f.name), 'wb') {|t| t << f.read }
      end
    end

    redirect_to project_upload_index_url(@project), notice: "#{params['upload']['files'].original_filename} のアップロードに成功しました。"
  end
end
