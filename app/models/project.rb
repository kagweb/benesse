# coding: utf-8
class Project < ActiveRecord::Base
  has_many :branches
  has_many :comments
  has_many :confirmations
  has_many :parties
  belongs_to :authorizer, class_name: 'User'
  belongs_to :promoter, class_name: 'User'
  belongs_to :operator, class_name: 'User'

  attr_accessible :authorizer_id, :code, :confirmed, :name, :production_upload_at, :production_upload_url, :promoter_id, :status, :test_upload_at, :upload_url

  after_create :create_branche

  private

  def create_branche
    branches.create code: (format("%07d", id) + '01') # テストしてない
  end
end
