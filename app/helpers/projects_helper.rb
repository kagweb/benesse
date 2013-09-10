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

  def break_dir ( dir )
    if dir[1].instance_of? String
      return "<li class=\"file\"><i class=\"icon-file\"></i> #{dir[0]}</li>"
    end

    element = "<li class=\"folder\"><i class=\"icon-folder-open\"></i> #{dir[0]}<ul class=\"unstyled\">"

    dir[1].each do |d|
      element += break_dir d
    end
    return element + "</ul></li>"
  end
end
