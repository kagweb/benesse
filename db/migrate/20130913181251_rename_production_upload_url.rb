class RenameProductionUploadUrl < ActiveRecord::Migration
  def up
    rename_column 'projects', 'production_upload_url', 'exists_test_server'
  end

  def down
    rename_column 'projects', 'exists_test_server', 'production_upload_url'
  end
end
