# -*- coding: utf-8 -*-
module ProjectsHelper

  def create_projects_url_by_month(type)
    days = []
    if params['q']
      ['gt', 'lt'].each do |d|
        days << Date.new(params['q']["production_upload_at_#{d}eq(1i)"].try(:to_i) || Time.now.year, params['q']["production_upload_at_#{d}eq(2i)"].try(:to_i) || Time.now.month, 1)
      end
    else
      2.times {|i| days << Date.new(Time.now.year, Time.now.month, 1)}
    end

    date = type == 'next' ? days[1] >> 1 : days[0] << 1
    last_date = (date >> 1) - 1

    return projects_url q: {
      'production_upload_at_gteq(1i)' => date.year,
      'production_upload_at_gteq(2i)' => date.month,
      'production_upload_at_gteq(3i)' => date.day,
      'production_upload_at_lteq(1i)' => last_date.year,
      'production_upload_at_lteq(2i)' => last_date.month,
      'production_upload_at_lteq(3i)' => last_date.day,
      'production_upload_at_lteq(4i)' => 23,
      'production_upload_at_lteq(5i)' => 59,
    }
  end

  def disabled ( place )
    case place
#     when 'aws'
#       return 'disabled' if @project.status <= 1
    when 'test'
      return 'disabled' if @project.status <= 3
    when 'production'
      return 'disabled' if @project.status <= 5
    end

    return ''
  end

  def confirmation_enabled?(project)
    (params[:status] == 'aws' and project.status <= 2) or
    (params[:status] == 'test' and project.status == 4) or
    (params[:status] == 'production' and project.status == 6)
  end

  def status_slug(code)
    return code if ['aws', 'test', 'production'].include? code
    status = { 0 => 'aws', 1 => 'aws', 2 => 'aws', 3 => 'test', 4 => 'test', 5 => 'production', 6 => 'production', 7 => 'closed' }
    return status[code.to_i] || 'aws'
  end

  def status_code(slug)
    return slug if [0..2].include? slug
    status = { 'aws' => 0, 'test' => 1, 'production' => 2 }
    return status[slug]
  end

  def response ( user, status = @status )
    confirmation = user.confirmations.where project_id: @project.id, status: status
    return confirmation.empty? ? '' : confirmation.last.response
  end

  def folder ( name, info )
    unless info['type'] == 'dir'
      # ファイルの情報
      tmp  = content_tag :a, '<i class="icon-file"></i> ' + name + ' ', { href: info['basepath'] + '/' + info['path'], data: {root: info['root']}}, false
      tmp += content_tag :div, info['updated_at'], {class: 'pull-right span2 file_info'}, false
      tmp += content_tag :div, info['size'], {class: 'pull-right span1 file_info'}, false
      tmp += content_tag :div, info['type'], {class: 'pull-right span1 file_info'}, false

      # ディレクトリでない場合は li 要素を返す
      return content_tag :li, tmp, {class: 'file'}, false
    end

    tmp  = content_tag :span, '&#9658;', {class: 'folder-control folder-close'}, false
    tmp += content_tag :a, '<i class="icon-folder-close"></i> ' + name, {href: info['basepath'] + '/' + info['path'], data: {root: info['root']}}, false

    # ディレクトリの場合はディレクトリの中身を再帰的に解析
    ul = content_tag :ul, class: 'unstyled' do
      info['files'].each {|n, i| concat folder(n, i)}
    end

    content_tag :li, tmp + ul, nil, false
  end

  def directory_to_array(depth = nil)
    require "find"

    path = _create_path
    return [] unless path and File.exist? path

    dir = {}

    Find.find path do |file|
      next if FileTest.file? file and ['.DS_Store', '.gitkeep'].include? file.to_s.split('/').last
      resolved_path = file.to_s.gsub(path.to_s, '').gsub(/^\//, '').split /\//
      next if resolved_path.empty?

      tmp = dir
      depth_count = 0
      template = {
        'root' => resolved_path.first,
        'path' => resolved_path.join('/'),
        'basepath' => path.to_s.gsub(Benesse::Application.config.upload_root_path.to_s, '').gsub(/^\//, ''),
        'type' => 'dir',
        'size' => '',
        'files' => {},
        'updated_at' => l(File.mtime file),
      }

      resolved_path.each do |r|
        depth_count += 1
        tmp[r] = template.clone if ! tmp.key? r

        if FileTest.directory? file and depth_count == resolved_path.length
          tmp[r]['size'] = 0
          Dir.glob("#{file.to_s}/**/*") {|f| tmp[r]['size'] += File.size?(f).to_i }
          tmp[r]['size'] = number_to_human_size(tmp[r]['size']) || 'empty'
          break
        end

        if FileTest.file? file and depth_count == resolved_path.length
          tmp[r]['type'] = r.split('.').last.upcase
          tmp[r]['size'] = number_to_human_size(File.size? file) || 'empty'
          break
        end

        tmp = tmp[r]['files']
        break if ! depth.nil? and depth_count >= depth
      end
    end

    return dir
  end

  private

  def _create_path
    if params[:path].present?
      path = Benesse::Application.config.upload_root_path.join params[:path]
      path = Pathname.new path.to_s.gsub(/#{path.to_s.split('/').last}$/, '').gsub(/\/$/, '') if FileTest.file? path
      return path
    end
    return Benesse::Application.config.upload_aws_path if params[:id].blank?

    project = Project.find params[:id]
    env = _sanitize_env params[:env]
    project_code = _sanitize_project_code project, params[:branch_code]
    path = Benesse::Application.config.upload_projects_path.join(env).join(project_code)
    return path.exist? ? path : false
  end

  def _sanitize_env(env)
    return ['test', 'production'].include?(env) ? env : 'production'
  end

  def _sanitize_project_code(project, branch)
    branch_code = branch.presence || project.branches.last.code
    project_code = format("%07d", project.id)
    return project_code + '/' + format("%02d", branch_code.to_i)
  end
end
