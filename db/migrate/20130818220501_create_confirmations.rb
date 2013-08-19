class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.with_options null: false  do |t|
        t.references :project
        t.references :user
        t.integer :status, default: 0
        t.string :type
      end

      t.timestamps
    end
    add_index :confirmations, :project_id
    add_index :confirmations, :user_id
  end
end
