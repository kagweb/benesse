class Party < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :mail_send_cc, :mail_send_to, :required

  before_create :check_deplicated_user

  private

  def check_deplicated_user
    ! exists_user?
  end

  def exists_user?
    ! project.parties.find_by_user_id(user.id).blank?
  end
end
