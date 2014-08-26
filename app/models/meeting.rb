class Meeting < ActiveRecord::Base
  has_many :meeting_materials
  accepts_nested_attributes_for :meeting_materials, 
    allow_destroy: true,
    reject_if: lambda { |attributes| attributes['file_name'].blank? }
end
