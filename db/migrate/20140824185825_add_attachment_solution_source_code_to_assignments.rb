class AddAttachmentSolutionSourceCodeToAssignments < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|
      t.attachment :solution_source_code
    end
  end

  def self.down
    remove_attachment :assignments, :solution_source_code
  end
end
