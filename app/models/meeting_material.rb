class MeetingMaterial < ActiveRecord::Base
  belongs_to :meeting
  has_attached_file :material

  validates_attachment :material, size: { in: 0..10.megabytes }
end