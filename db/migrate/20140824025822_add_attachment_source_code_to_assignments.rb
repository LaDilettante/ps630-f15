class AddAttachmentSourceCodeToAssignments < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|
      t.attachment :source_code
    end
  end

  def self.down
    remove_attachment :assignments, :source_code
  end
end
