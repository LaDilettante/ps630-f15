class Assignment < ActiveRecord::Base
  has_many :homework_documents

  validates :deadline, presence: true
end
