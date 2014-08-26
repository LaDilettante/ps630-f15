class AddMeetingIdToMeetingMaterials < ActiveRecord::Migration
  def change
    add_column :meeting_materials, :meeting_id, :integer
  end
end
