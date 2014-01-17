# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_return_to_url

  protected

  def set_return_to_url
    session[:benesse_return_to_url] = request.url
  end

  def return_to_url
    session[:benesse_return_to_url] || root_rul
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

  def create_zip(path)
    path = Benesse::Application.config.upload_root_path.join.join(path) unless path.to_s =~ /^#{Benesse::Application.config.upload_root_path}/
    return false unless File.exist? path

    resolved_path = path.to_s.split /\//
    return false if resolved_path.blank?

    tmp_filename = resolved_path.pop + '_' + Time.now.strftime("%Y%m%d%H%M%S%L") + '.zip'
    reduce_path  = resolved_path.join '/'

    Zip::File.open Benesse::Application.config.upload_tmp_path.join(tmp_filename).to_s, Zip::File::CREATE do |archive|
      Dir.glob(path.join('**/*').to_s).each do |path|
        archive.add path.to_s.gsub(reduce_path, '').gsub(/^\//, ''), path
      end
    end

    return Benesse::Application.config.upload_tmp_path.join tmp_filename
  end

  def unzip(tmp_file_path, target_dir_path)
    unexpect_extname_flag = false
    unexpect_character_flag = false

    Zip::File.open(tmp_file_path) do |zip|
      zip.each do |file|
        filename = file.to_s.force_encoding("UTF-8")

        ## __MACOSX の削除
        next if filename =~ /^__MACOSX/

        if file.directory?
          FileUtils.mkdir_p(target_dir_path.join filename)
          next
        end

        # 許可されていない拡張子ファイルの場合、スキップする
        unless Benesse::Application.config.accept_extnames.include? filename.split('.').last
          unexpect_extname_flag = true
          next
        end

        if filename =~ /[^ -~｡-ﾟ]/
          unexpect_character_flag = true
          next
        end

        if file.file?
          dirname = File.dirname filename
          dirnames = dirname.split('/')
          current_path = target_dir_path
          dirnames.each do |dirname|
            current_path = current_path.join dirname
            FileUtils.mkdir_p(current_path)
          end
        end

        # { true } は展開先に同名ファイルが存在する場合に上書きする指定
        zip.extract file, target_dir_path.join(filename) do |dest_path|
          true
        end
      end
    end

    flash[:alert] = []
    flash[:alert] << "許可されていない拡張子のファイルをスキップしました。\n" if unexpect_extname_flag
    flash[:alert] << "ファイル名にマルチバイト文字が含まれているファイルをスキップしました。" if unexpect_character_flag

    return true
  end

  def create_tmp_file(file)
    filename = Time.now.strftime("%Y%m%d%H%M%S%L") + '_' + file.original_filename
    filepath = Benesse::Application.config.upload_tmp_path.join filename
    FileUtils.mkdir_p Benesse::Application.config.upload_tmp_path
    fs = File.open filepath, 'w'
    fs.write file.read.force_encoding('UTF-8')
    fs.close

    return filepath
  end

  def remove_tmp_file(path)
    File.delete path if File.exist? path and path.to_s =~ /^#{Benesse::Application.config.upload_tmp_path}/
  end
end
