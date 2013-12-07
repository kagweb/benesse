module ApplicationHelper
  def project_number(project)
    return "#{project.number}-#{format "%02d", project.branches.last.code.to_i}"
  end

  def allow?(*authorities)
    return true if current_user.is_promotion_department?

    authorities.each do |a|
      case a
      when 'authorizer'
        return true if @project.authorizer == current_user
      when 'promoter'
        return true if @project.promoter == current_user
      when 'operator'
        return true if @project.operator == current_user
      end
    end

    return false
  end

  def deny?(*authorities)
    return true if current_user.is_promotion_department?

    authorities.each do |a|
      case a
      when 'authorizer'
        return false if @project.authorizer == current_user
      when 'promoter'
        return false if @project.promoter == current_user
      when 'operator'
        return false if @project.operator == current_user
      end
    end

    return false
  end
end
