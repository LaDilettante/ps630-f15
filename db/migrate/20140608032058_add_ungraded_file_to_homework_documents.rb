class AddUngradedFileToHomeworkDocuments < ActiveRecord::Migration
  def self.up
    add_attachment :homework_documents, :ungraded_file
  end

  def self.down
    remove_attachment :homework_documents, :ungraded_file
  end
end
