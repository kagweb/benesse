# coding: utf-8
if Rails.env.development?
  ActiveRecord::Base.connection.tables.map { |table| Object.const_get(table.classify) rescue nil }.compact.each do |_class|
    _class.delete_all
  end

  ['デジタル推進課', '部署1', '部署2'].each do |name|
    Department.create name: name
  end

  department = Department.find_by_name('デジタル推進課')
  user = department.users.create username: 'user', name: 'ベネッセ太郎', email: 'admin@mail.benesse.co.jp', password: 'secret', password_confirmation: 'secret'

  100.times { |i|
    Project.create name: "プロジェクト#{i}", promoter_id: user.id
  }
end
