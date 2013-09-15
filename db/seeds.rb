# coding: utf-8

if Rails.env.development?
  ActiveRecord::Base.connection.tables.map { |table| Object.const_get(table.classify) rescue nil }.compact.each do |_class|
    _class.delete_all
  end
end

# デジタル推進課と業者は、テスト・本番共通の部署
department = Department.create name: 'デジタル推進課'
supplier   = Department.create name: '業者'
admin      = department.users.create(username: 'admin', name: '開発用管理者', email: 'admin@mail.benesse.co.jp', password: '042745fd3764fe5bde8affa1737d73f0ffeb2190', password_confirmation: '042745fd3764fe5bde8affa1737d73f0ffeb2190')

if Rails.env.development?
  users = []

  ['部署1', '部署2', '部署3'].each do |name|
    tmp = Department.create name: name

    # 各プロジェクトの関係者として利用するテストユーザ
    10.times do |i|
      users << tmp.users.create(username: "user#{tmp.id}_#{i}", name: "テストユーザ#{i}", email: "user#{tmp.id}_#{i}@mail.benesse.co.jp", password: 'secret', password_confirmation: 'secret')
    end
  end

  # 開発用ログインユーザ
  creator = supplier.users.create(username: 'clustium', name: 'clustium Inc.', email: 'info@clustium.com', password: 'secret', password_confirmation: 'secret')

  projects = []

  100.times do |i|
    project = Project.new name: "プロジェクト#{i}", memo: "プロジェクト#{i}のメモ。 " * 10
    project.test_upload_at = Date.new 2013, rand(9..10), rand(1..30)
    project.production_upload_at = project.test_upload_at + (rand 10..30).day
    project.upload_server = Benesse::Application.config.servers[rand(Benesse::Application.config.servers.length)]
    project.authorizer = admin
    project.promoter   = admin
    project.operator   = admin
    project.save
    projects << project
  end

  projects.each do |project|
    parties = []
    # 開発用ログインユーザを各プロジェクトの関係者にアサイン
    party = project.parties.new required: true
    party.project = project
    party.user = admin
    party.save
    parties << admin

    # 関係者を3~5人適当に登録
    (rand 2..5).times do |i|
      party = project.parties.new required: rand(2) == 1
      party.project = project
      party.user = users[rand(users.length)]
      party.save
      parties << party.user
    end

    # コメントを登録
    (rand 5..10).times do |i|
      0..3.times do |status|
        comment = project.comments.new status: status, comment: 'コメントのテストです。' * 10
        comment.user = parties[rand(parties.length)]
        comment.save
      end
    end
  end

end
