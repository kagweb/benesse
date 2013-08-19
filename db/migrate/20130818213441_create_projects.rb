class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.with_options null: false  do |t|
        t.string :code
         t.string :name
         t.integer :promoter_id, null: false
         t.integer :status, default: 0
         t.boolean :confirmed, default: false
       end
       t.integer :authorizer_id
       t.integer :operator_id
       t.string :upload_url
       t.string :production_upload_url
       t.datetime :test_upload_at
       t.datetime :production_upload_at

       t.timestamps
     end
  end
end
