class Project < ActiveRecord::Base
  has_many :branches
  has_many :comments
  has_many :confirmations
  has_many :parties
  has_one :authorizer, class_name: 'User'
  has_one :promoter, class_name: 'User'
  has_one :operator, class_name: 'User'

  attr_accessible :authorizer_id, :code, :confirmed, :name, :production_upload_at, :production_upload_url, :promoter_id, :status, :test_upload_at, :upload_url
end
