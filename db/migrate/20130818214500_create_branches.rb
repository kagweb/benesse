class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :project, null: false
      t.string :code, null: false

      t.timestamps
    end
    add_index :branches, :project_id
  end
end
