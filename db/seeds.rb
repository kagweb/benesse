# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  ActiveRecord::Base.connection.tables.map { |table| Object.const_get(table.classify) rescue nil }.compact.each do |_class|
    _class.delete_all
  end

  ['デジタル推進課', '部署1', '部署2'].each do |name|
    Department.create name: name
  end

  department = Department.find_by_name('デジタル推進課')
  user = department.users.create username: 'user', email: 'admin@mail.benesse.co.jp', password: 'secret', password_confirmation: 'secret'

end
