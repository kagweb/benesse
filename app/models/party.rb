class Party < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :mail_send_cc, :mail_send_to, :required
end
