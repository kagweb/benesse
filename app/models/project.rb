class Project < ActiveRecord::Base
  attr_accessible :authorizer_id, :code, :confirmed, :name, :operator_id, :production_upload_at, :production_upload_url, :promoter_id, :status, :test_upload_at, :upload_url
end
