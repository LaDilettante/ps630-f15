class ChangeDefaultGradedValueInAssignment < ActiveRecord::Migration
  def change
    change_column :assignments, :graded, :boolean, :default => false
  end
end
