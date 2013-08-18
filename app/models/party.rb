class Party < ActiveRecord::Base
  attr_accessible :mail_send_cc, :mail_send_to, :project_id, :required, :user_id
end
