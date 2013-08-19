class Confirmation < ActiveRecord::Base
  has_many :projects
  has_many :users

  attr_accessible :status, :type
end
