class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :title
      t.datetime :time

      t.timestamps
    end
  end
end
