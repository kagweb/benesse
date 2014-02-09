# -*- coding: utf-8 -*-
class Party < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :mail_send_cc, :mail_send_to, :aws_confirm_required, :test_confirm_required, :production_confirm_required

  before_create :check_deplicated_user
  after_destroy :delete_confirmations
  after_destroy :check_status

  validates :user, presence: true

  private

  def check_deplicated_user
    project.parties.find_by_user_id(user.id).blank?
  end

  def delete_confirmations
    user.confirmations.destroy
    Confirmation.where(project_id: project.id, user_id: user.id).destroy_all
  end

  def check_status
    project.check_status
  end
end
