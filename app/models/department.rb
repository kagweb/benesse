class Department < ActiveRecord::Base
  has_many :users

  attr_accessible :name

  before_create :check_deplicated_name

  def check_deplicated_name
    ! Department.pluck(:name).include? name
  end
end
