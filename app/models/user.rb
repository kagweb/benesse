class User < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :department
  has_many :comments
  has_many :confirmations
  has_many :parties
  has_many :projects

  attr_accessible :username, :email, :password, :password_confirmation, :department_id

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :password, minimum: 6, if: :password
  validates_confirmation_of :password, if: :password
end
