# coding: utf-8
class Project < ActiveRecord::Base
  has_many :branches
  has_many :comments
  has_many :confirmations
  has_many :parties
  belongs_to :authorizer, class_name: 'User'
  belongs_to :promoter, class_name: 'User'
  belongs_to :operator, class_name: 'User'

  attr_accessible :code, :confirmed, :name, :production_upload_at, :production_upload_url, :status, :test_upload_at, :upload_url

  after_create :create_branch

  def update_branch
    branches.create code: format("%02d", branches.last.code.to_i + 1)
  end

  private

  def create_branch
    branches.create code: '01'
  end
end
