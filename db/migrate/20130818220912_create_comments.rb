class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.with_options null: false  do |t|
        t.references :project
        t.references :user
        t.integer :status, default: 0
        t.text :comment
      end

      t.timestamps
    end
    add_index :comments, :project_id
    add_index :comments, :user_id
  end
end
