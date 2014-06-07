class AddGradedToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :graded, :boolean
  end
end
