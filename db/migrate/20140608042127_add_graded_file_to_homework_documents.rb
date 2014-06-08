class AddGradedFileToHomeworkDocuments < ActiveRecord::Migration
  def self.up
    add_attachment :homework_documents, :graded_file
  end

  def self.down
    remove_attachment :homework_documents, :graded_file
  end
end
