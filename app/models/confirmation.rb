class Confirmation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :status, :response

  after_save :check_status

  private

  def check_status
    updated = true
    project.parties.each do |party|
      next unless party.required
      updated = false unless 'ok' == party.user.confirmations.find_by_status(project.status_code).try(:response)
    end

    if updated
      project.status += 1
      project.save
    end
  end
end
