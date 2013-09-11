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

  def break_dir ( name, info )
    return '' if name == '_path_'
    return "<li><a href=\"#{info}\"><i class=\"icon-file\"></i> #{name}</a></li>" if info.instance_of? String
    element = "<li><a href=\"#{info['_path_']}\"><i class=\"icon-folder-open\"></i> #{name}</a><ul class=\"unstyled\">"
    info['_files_'].each {|n, i| element += break_dir n, i }

    return element + "</ul></li>"
  end
end
