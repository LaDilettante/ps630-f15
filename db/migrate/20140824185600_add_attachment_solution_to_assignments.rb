class AddAttachmentSolutionToAssignments < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|
      t.attachment :solution
    end
  end

  def self.down
    remove_attachment :assignments, :solution
  end
end
