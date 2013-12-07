class AddColumnNumberToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :number, :string, after: :id
  end
end
