class DropEmployeesAndProjects < ActiveRecord::Migration
  def change
    drop_table :employees_and_projects
  end
end
