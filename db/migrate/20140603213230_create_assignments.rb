class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.text :title
      t.text :body
      t.datetime :deadline
      t.decimal :max_grade

      t.timestamps
    end
  end
end
