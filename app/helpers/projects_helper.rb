module ProjectsHelper

  def now_status ( project, place )
    case place
    when 'html'
      return 'preparing'  if project.status == 0
      return 'no_upload'  if project.status == 1
      return 'working'    if project.status == 2
      return 'compleated' if project.status >= 3
    when 'test'
      return 'no_upload'  if project.status == 3
      return 'working'    if project.status == 4
      return 'compleated' if project.status >= 5
    when 'production' 
      return 'no_upload'  if project.status == 5
      return 'working'    if project.status == 6
      return 'compleated' if project.status >= 7
    end

    return 'blank'
  end

  def disabled ( place )
    case place
    when 'html'
      return 'disabled' if @project.status == 0
    when 'test'
      return 'disabled' if @project.status <= 3
    when 'production'
      return 'disabled' if @project.status <= 5
    end

    return ''
  end

  def status_slug(code)
    return code if ['html', 'test', 'production'].include? code
    status = { 0 => 'html', 1 => 'html', 2 => 'html', 3 => 'test', 4 => 'test', 5 => 'production', 6 => 'production', 7 => 'closed' }
    return status[code.to_i]
  end

  def status_code(slug)
    return slug if [0..2].include? slug
    status = { 'html' => 0, 'test' => 1, 'production' => 2 }
    return status[slug]
  end

  def response ( user, status = @status )
    confirmation = user.confirmations.where project_id: @project.id, status: status
    return confirmation.empty? ? '' : confirmation.last.response
  end

  def folder ( name, info )
    # ファイルの情報
    tmp  = "<div class=\"pull-right span2\">#{info['_updated_at_']} </div>"
    tmp += "<div class=\"pull-right span1\">#{info['_size_']}</div>"
    tmp += "<div class=\"pull-right span1\">#{info['_type_'].upcase}</div>"

    # ディレクトリでない場合は li 要素を返す
    return "<li class=\"file\"><a href=\"#{info['_basepath_']}/#{info['_path_']}\" data-root=\"#{info['_root_']}\"><i class=\"icon-file\"></i> #{name} #{tmp} </a></li>" unless info['_type_'] == 'dir'

    # ディレクトリの場合はディレクトリの中身を再帰的に解析
    element = "<li><span class=\"folder-control folder-close\">&#9658;</span><a href=\"#{info['_basepath_']}/#{info['_path_']}\" data-root=\"#{info['_root_']}\"><i class=\"icon-folder-close\"></i> #{name}</a><ul class=\"unstyled\">"
    info['_files_'].each {|n, i| element += folder n, i }

    return element + "</ul></li>"
  end

  def list_path
    return false if params[:path].blank?
    path = Rails.root.join URI.unescape params[:path]
    return false unless path.exist?
    return path
  end

  def dir_to_a(depth = nil)
    require "find"

    path = _create_path
    return [] unless path

    dir = {}

    Find.find path do |f|
      next if FileTest.file? f and ['.DS_Store', '.gitkeep'].include? f.split('/').last
      resolved_path = f.to_s.gsub(path.to_s, '').gsub(/^\//, '').split /\//
      next if resolved_path.empty?

      tmp = dir
      count = 0

      resolved_path.each do |r|
        count += 1

        if FileTest.file? f and count == resolved_path.length
          tmp[r] = {
            '_root_' => resolved_path.first,
            '_path_' => resolved_path.join('/'),
            '_basepath_' => path.to_s.gsub(Rails.root.to_s, '').gsub(/^\//, ''),
            '_type_' => r.split('.').last.upcase,
            '_size_' => number_to_human_size(File.size? f) || 'empty',
            '_updated_at_' => l(File.mtime f),
          }
          break
        elsif ! tmp.key? r
          tmp[r] = {
            '_root_' => resolved_path.first,
            '_path_' => resolved_path.join('/'),
            '_basepath_' => path.to_s.gsub(Rails.root.to_s, '').gsub(/^\//, ''),
            '_type_' => 'dir',
            '_size_' => number_to_human_size(File.size? f ) || 'empty',
            '_updated_at_' => l(File.mtime f),
            '_files_' => {},
          }
        end

        tmp = tmp[r]['_files_']
        break if ! depth.nil? and count >= depth
      end
    end

    return dir
  end

  private

  def _create_path
    return Rails.root.join('files/aws') if params[:id].blank?

    project = Project.find params[:id]
    env = _sanitize_env params[:env]
    project_code = _sanitize_project_code project, params[:branch_code]
    path = Rails.root.join('files/projects').join(env).join(project_code)
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
