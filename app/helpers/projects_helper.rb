module ProjectsHelper

  def now_status ( place )
    case place
    when 'html'
      return @project.status == 0 ? 'working' : 'compleated'
    when 'test'
      if @project.status == 1
        return 'working'
      elsif @project.status >= 2
        return 'compleated'
      end
    when 'production' 
      if @project.status == 2
        return 'working'
      elsif @project.status == 3
        return 'compleated'
      end
    end

    return 'preparing'
  end

  def disabled ( place )
    case place
    when 'html'
      return ''
    when 'test'
      return 'disabled' if @project.status < 1
    when 'production'
      return 'disabled' if @project.status < 2
    end

    return ''
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
    return "<li class=\"file\"><a href=\"#{info['_path_']}\"><i class=\"icon-file\"></i> #{name} #{tmp} </a></li>" unless info['_type_'] == 'dir'

    # ディレクトリの場合はディレクトリの中身を再帰的に解析
    element = "<li><a href=\"#{info['_path_']}\"><i class=\"icon-folder-open\"></i> #{name}</a><ul class=\"unstyled\">"
    info['_files_'].each {|n, i| element += folder n, i }

    return element + "</ul></li>"
  end

  def list_path
    return false if params[:path].blank?
    path = Rails.root.join URI.unescape params[:path]
    return false unless path.exist?
    return path
  end

  def get_dir_structure(path, depth = nil)
    require "find"

    path = Rails.root.join path
    return false unless path.exist?

    dir = {}

    Find.find path do |f|
      resolved_path = f.to_s.gsub(Rails.root.to_s, '').gsub(/^\//, '').split /\//
      next if resolved_path.empty?

      tmp = dir
      count = 0

      resolved_path.each do |r|
        count += 1

        if FileTest.file? f and count == resolved_path.length
          tmp[r] = {
            '_path_' => resolved_path.join('/'),
            '_type_' => r.split('.').last.upcase,
            '_size_' => number_to_human_size(File.size? f) || 'empty',
            '_updated_at_' => l(File.mtime f),
          }
          break
        elsif ! tmp.key? r
          tmp[r] = {
            '_path_' => resolved_path.join('/'),
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
end
