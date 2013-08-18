class Confirmation < ActiveRecord::Base
  attr_accessible :project_id, :status, :type, :user_id
end
