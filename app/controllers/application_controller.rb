# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_return_to_url

  protected

  def set_return_to_url
    session[:return_to_url] = request.url
  end

  def is_promotion_department?
    current_user && current_user.is_promotion_department?
  end

  def promotion_department_required
    redirect_to root_url, alert: '管理者権限が必要です' unless is_promotion_department?
  end

  def is_supplier_department?
    current_user && current_user.is_supplier_department?
  end

  def supplier_department_except
    return unless is_supplier_department?
    logout
    redirect_to root_url, alert: 'アクセス権がありません。'
  end

  def _create_zip(path)
    resolved_path = path.to_s.split /\//
    tmp_filename  = resolved_path.pop + '_' + Time.now.strftime("%Y%m%d%H%M%S%L") + '.zip'
    reduce_path   = resolved_path.join('/')

    Zip::Archive.open Benesse::Application.config.upload_tmp_path.join(tmp_filename).to_s, Zip::CREATE do |archive|
      Dir.glob(path.join('**/*').to_s).each do |path|
        filename = path.to_s.gsub(reduce_path, '').gsub(/^\//, '')
        File.directory?(path) ? archive.add_dir(filename) : archive.add_file(filename, path)
      end
    end

    return Benesse::Application.config.upload_tmp_path.join tmp_filename
  end

  def _unzip(file, path)
    filename  = _create_tmp_file(file)
    Zip::Archive.open Benesse::Application.config.upload_tmp_path.join(filename).to_s do |archive|
      archive.each do |f|
        ## __MACOSX の削除
        next if f.name =~ /^__MACOSX/

        if f.directory?
          FileUtils.mkdir_p(path.join f.name)
          next
        end

        # 許可されていない拡張子ファイルの場合、スキップする
        next unless Benesse::Application.config.accept_extnames.include? f.name.split('.').last.split('.').last
        dirname = File.dirname(path.join f.name)
        FileUtils.mkdir_p dirname unless File.exist? dirname
        open(path.join(f.name), 'wb') {|t| t << f.read }
      end
    end
  end

  def _create_tmp_file(file)
    filename = Time.now.strftime("%Y%m%d%H%M%S%L") + '_' + file.original_filename
    FileUtils.mkdir_p Benesse::Application.config.upload_tmp_path
    fs = File.open Benesse::Application.config.upload_tmp_path.join(filename), 'w'
    fs.write file.read.force_encoding('UTF-8')
    fs.close

    return filename
  end
end
