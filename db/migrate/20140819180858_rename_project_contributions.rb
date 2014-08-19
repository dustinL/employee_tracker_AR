class RenameProjectContributions < ActiveRecord::Migration
  def change
    rename_table :project_contributions, :contributions
  end
end
