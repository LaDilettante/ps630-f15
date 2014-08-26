class AddMaterialColumnToMeetingMaterials < ActiveRecord::Migration
  def self.up
    add_attachment :meeting_materials, :material
  end

  def self.down
    remove_attachment :meeting_materials, :material
  end
end