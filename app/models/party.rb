class Party < ActiveRecord::Base
  has_many :projects
  has_many :users

  attr_accessible :mail_send_cc, :mail_send_to, :required
end
