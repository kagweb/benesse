class Department < ActiveRecord::Base
  has_many :users

  attr_accessible :name
end
