# coding: utf-8
class Project < ActiveRecord::Base
  has_many :branches
  has_many :comments
  has_many :confirmations
  has_many :parties
  belongs_to :authorizer, class_name: 'User'
  belongs_to :promoter, class_name: 'User'
  belongs_to :operator, class_name: 'User'

  attr_accessible :code, :confirmed, :name, :production_upload_at, :exists_test_server, :status, :test_upload_at, :upload_server, :registration_status, :year_migrate, :server_update, :memo, :register_datetime

  after_create :create_branch

  def status_slug
    tmp = { 0 => 'html', 1 => 'test', 2 => 'production', 3 => 'closed'}
    return tmp[self.status]
  end

  def update_branch
    branches.create code: format("%02d", branches.last.code.to_i + 1)
  end

  private

  def create_branch
    branches.create code: '01'
  end
end
