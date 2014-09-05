class MeetingMaterial < ActiveRecord::Base
  belongs_to :meeting
  has_attached_file :material,
    s3_headers: { 'Content-Disposition' => "attachment" }

  attr_accessor :delete_material
  before_validation { material.clear if delete_material == '1' }

  validates_attachment :material, size: { in: 0..10.megabytes }
end