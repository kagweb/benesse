class RenameUploadUrlToUploadServer < ActiveRecord::Migration
  def up
    rename_column 'projects', 'upload_url', 'upload_server'
  end

  def down
    rename_column 'projects', 'upload_server', 'upload_url'
  end
end
