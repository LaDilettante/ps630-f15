class AddUngradedFileSourceCodeToHomeworkDocuments < ActiveRecord::Migration
  def self.up
    add_attachment :homework_documents, :ungraded_file_source_code
  end

  def self.down
    remove_attachment :homework_documents, :ungraded_file_source_code
  end
end
