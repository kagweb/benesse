class Comment < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :comment, :status
end
