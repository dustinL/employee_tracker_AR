class UpdateEmployeesProjects < ActiveRecord::Migration
  def change
    add_column :employees_projects, :contribution, :string
    rename_table :employees_projects, :project_contributions
  end
end
