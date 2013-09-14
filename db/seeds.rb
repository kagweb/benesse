# coding: utf-8
if Rails.env.development?
  ActiveRecord::Base.connection.tables.map { |table| Object.const_get(table.classify) rescue nil }.compact.each do |_class|
    _class.delete_all
  end

  users = []

  ['デジタル推進課', '部署1', '部署2', '部署3'].each do |name|
    department = Department.create name: name

    # 各プロジェクトの関係者として利用するテストユーザ
    20.times do |i|
      users << department.users.create(username: "user#{department.id}_#{i}", name: "テストユーザ#{i}", email: "user#{department.id}_#{i}@mail.benesse.co.jp", password: 'secret', password_confirmation: 'secret')
    end
  end

  department = Department.find_by_name('デジタル推進課')

  # 開発用ログインユーザ
  user = department.users.create(username: 'user', name: 'ベネッセ太郎', email: 'admin@mail.benesse.co.jp', password: 'secret', password_confirmation: 'secret')

  projects = []

  100.times do |i|
    project = Project.new name: "プロジェクト#{i}", memo: "プロジェクト#{i}のメモ。 " * 10
    project.test_upload_at = Date.new 2013, rand(9..10), rand(1..30)
    project.production_upload_at = project.test_upload_at + (rand 10..30).day
    project.authorizer = user
    project.promoter = user
    project.operator = user
    project.save
    projects << project
  end

  projects.each do |project|
    parties = []
    # 開発用ログインユーザを各プロジェクトの関係者にアサイン
    party = project.parties.new required: true
    party.project = project
    party.user = user
    party.save
    parties << user

    # 関係者を5~10人適当に登録
    (rand 5..10).times do |i|
      party = project.parties.new required: rand(2) == 1
      party.project = project
      party.user = users[rand(users.length)]
      party.save
      parties << party.user
    end

    # コメントを登録
    (rand 10..20).times do |i|
      0..3.times do |status|
        comment = project.comments.new status: status, comment: 'コメントのテストです。'
        comment.user = parties[rand(parties.length)]
        comment.save
      end
    end
  end

end
