module ProjectsHelper

  def status ( place )
    if place == 'html'
      if @project.status == 0
        return 'working'
      else
        return 'compleated'
      end
    elsif place == 'test'
      if @project.status == 1
        return 'working'
      elsif @project.status >= 2
        return 'compleated'
      end
    elsif place == 'production' 
      if @project.status == 2
        return 'working'
      elsif @project.status == 3
        return 'compleated'
      end
    end

    return 'preparing'
  end

  def disabled ( place )
    if place == 'html'
      return ''
    elsif place == 'test' and @project.status < 1
      return 'disabled'
    elsif place == 'production' and @project.status < 2
      return 'disabled'
    end

    return ''
  end
  
  def response ( user, status = @status )
    confirmation = user.confirmations.find :first, conditions: { project_id: @project.id, status: status }
    return confirmation ? confirmation.response : ''
  end

  def break_dir ( name, info )
    return '' if name == '_path_'
    return "<li><a href=\"#{info}\"><i class=\"icon-file\"></i> #{name}</a></li>" if info.instance_of? String
    element = "<li><a href=\"#{info['_path_']}\"><i class=\"icon-folder-open\"></i> #{name}</a><ul class=\"unstyled\">"
    info['_files_'].each {|n, i| element += break_dir n, i }

    return element + "</ul></li>"
  end
end
