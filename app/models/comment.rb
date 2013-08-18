class Comment < ActiveRecord::Base
  attr_accessible :comment, :project_id, :status, :user_id
end
