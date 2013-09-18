class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.with_options null: false do |t|
        t.references :project
        t.references :user
        t.with_options default: false do |t|
          t.boolean :required
          t.boolean :mail_send_to
          t.boolean :mail_send_cc
        end
      end

      t.timestamps
    end
    add_index :parties, :project_id
    add_index :parties, :user_id
  end
end
