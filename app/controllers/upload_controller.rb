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

    if params['upload'].blank? or params['upload']['files'].blank?
      redirect_to project_upload_index_path @project
      return
    end

    # file が zip形式かチェック

    file = params['upload']['files']
    filename = Time.now.strftime("%Y%m%d%H%M%S%L") + '_' + file.original_filename
    path = Rails.root.join 'tmp/upload'
    FileUtils.mkdir_p path

    fs = File.open path.join(filename), 'w'
    fs.write file.read.force_encoding("UTF-8")
    fs.close

    pp '=============================='
    Zip::Archive.open(path.join(filename).to_s) do |ar|
      ar.num_files.times do |i|
        entry_name = ar.get_name(i)
        ar.fopen(entry_name) do |f|
          name = f.name           # name of the file
          size = f.size           # size of file (uncompressed)
          comp_size = f.comp_size # size of file (compressed)

          content = f.read # read entry content
          pp f.name
        end
      end

      # Zip::Archive includes Enumerable
      entry_names = ar.map do |f|
        f.name
      end
    end

    redirect_to project_upload_index_path @project
  end
end
