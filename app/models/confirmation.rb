class Confirmation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :status, :response

  after_save :check_status

  private

  def check_status
    return false unless [2,4,6].include? project.status

    updated = true

    project.parties.each do |party|
      next unless party.required
      updated = false unless 'ok' == party.user.confirmations.find_by_status(status).try(:response)
    end

    pp project.status
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

    pp project.status
  end
end
