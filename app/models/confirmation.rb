class Confirmation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :status, :response
end
