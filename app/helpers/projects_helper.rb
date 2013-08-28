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

end
