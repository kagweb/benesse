class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code, :null => false
      t.string :name, :null => false
      t.integer :authorizer_id, :null => false
      t.integer :promoter_id, :null => false
      t.integer :operator_id, :null => false
      t.integer :status, :null => false, :default => 0
      t.boolean :confirmed, :null => false, :default => false
      t.string :upload_url, :null => false
      t.string :production_upload_url
      t.datetime :test_upload_at
      t.datetime :production_upload_at

      t.timestamps
    end
  end
end
