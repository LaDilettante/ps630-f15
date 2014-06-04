class CreateHomeworkDocuments < ActiveRecord::Migration
  def change
    create_table :homework_documents do |t|
      t.integer :grader_id
      t.integer :submitter_id
      t.integer :assignment_id
      t.text :content
      t.decimal :grade

      t.timestamps
    end
  end
end
