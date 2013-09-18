class Branch < ActiveRecord::Base
  belongs_to :project

  attr_accessible :code
end
