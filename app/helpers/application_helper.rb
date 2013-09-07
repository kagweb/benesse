module ApplicationHelper
  def project_number(project)
    return format("%07d", project.id.to_i) + '-' + format("%02d", project.branches.last.code.to_i)
  end
end
