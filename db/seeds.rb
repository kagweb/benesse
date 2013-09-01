# coding: utf-8
if Rails.env.development?
  ActiveRecord::Base.connection.tables.map { |table| Object.const_get(table.classify) rescue nil }.compact.each do |_class|
    _class.delete_all
  end

  users = []

  ['デジタル推進課', '部署1', '部署2', '部署3'].each do |name|
    department = Department.create name: name

    20.times do |i|
      users << department.users.create(username: "user#{department.id}_#{i}", name: "テストユーザ#{i}", email: "user#{department.id}_#{i}@mail.benesse.co.jp", password: 'secret', password_confirmation: 'secret')
    end
  end


  department = Department.find_by_name('デジタル推進課')

  # 開発用ログインユーザ
  user = department.users.create(username: 'user', name: 'ベネッセ太郎', email: 'admin@mail.benesse.co.jp', password: 'secret', password_confirmation: 'secret')

  projects = []

  100.times do |i|
    tmp = Project.new(name: "プロジェクト#{i}")
    tmp.authorizer = user
    tmp.promoter = user
    tmp.operator = user
    tmp.save
    projects << tmp
  end

  projects.each do |project|
    party = project.parties.new(required: true)
    party.project = project
    party.user = user
    party.save

    (rand 5..10).times do |i|
      party = project.parties.new(required: rand(2) == 1)
      party.project = project
      party.user = users[rand(users.length)]
      party.save
    end
  end

end
