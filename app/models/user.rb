class User < ActiveRecord::Base
  attr_accessible :crypted_password, :department_id, :email, :salt, :username
end
