class MeetingMaterial < ActiveRecord::Base
  belongs_to :meeting
  has_attached_file :material,
    s3_headers: { 'Content-Disposition' => "attachment" }

  validates_attachment :material, size: { in: 0..10.megabytes }
end