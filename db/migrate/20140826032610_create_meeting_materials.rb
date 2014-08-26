class CreateMeetingMaterials < ActiveRecord::Migration
  def change
    create_table :meeting_materials do |t|

      t.timestamps
    end
  end
end
