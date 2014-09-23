class AddUserIdColumnToHomeworkDocuments < ActiveRecord::Migration
  def change
    add_column :homework_documents, :user_id, :integer
  end
end
