class AddPenaltyToHomeworkDocuments < ActiveRecord::Migration
  def change
    add_column :homework_documents, :penalty, :float
  end
end
