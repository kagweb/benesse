# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :department
  has_many :comments
  has_many :confirmations
  has_many :parties
  has_many :projects

  attr_accessible :username, :name, :email, :password, :password_confirmation, :department_id

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :password, minimum: 6, if: :password
  validates_confirmation_of :password, if: :password

  default_scope order('id DESC')

  def is_promotion_department?
    department == Department.find_by_name('デジタル推進課')
  end

  def is_supplier_department?
    department == Department.find_by_name('業者')
  end
end
