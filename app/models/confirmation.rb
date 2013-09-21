class Confirmation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :status, :response

  after_save :check_status

  def check_status
    return false if ! [2,4,6].include? project.status or project.parties.find_all_by_required(true).blank?

    updated = true

    confirmation_status = { 2 => 0, 4 => 1, 6=> 2 }
    project.parties.each do |party|
      next unless party.required
      updated = false unless 'ok' == project.confirmations.where(user_id: party.user.id, status: confirmation_status[project.status]).first.try(:response)
    end

    if updated
      case project.status
        when 2
          project.status = 3
        when 4
          project.status = 5
        when 6
          project.status = 7
      end
      project.save
    end
  end
end
