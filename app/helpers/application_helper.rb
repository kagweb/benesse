module ApplicationHelper
  def project_number(project)
    return format("%07d", project.id.to_i) + '-' + format("%02d", project.branches.last.code.to_i)
  end

  def get_dir_structure(path = nil)
    require "find"

    # @todo 開発用のコードなのでサーバ情報が明確になったら削除
      path = Rails.root.join('sample_dir') if Rails.env.development? and path.nil?

    path = Pathname.new path if path.instance_of? Pathname
    return false unless path.exist?

    dir = {}

    Find.find Rails.root.join(path) do |f|
      resolved_path = f.to_s.gsub(path.to_s, '').gsub(/^\//, '').split /\//
      next if resolved_path.empty?
      tmp = dir
      count = 0

      resolved_path.each do |r|
        count += 1
        tmp[r] = { '_path_' => resolved_path.join('/'), '_files_' => {} } unless tmp.key? r
        tmp[r] = resolved_path.join('/') if FileTest.file? f and count == resolved_path.length
        tmp    = tmp[r]['_files_']
      end
    end

    return dir
  end
end
