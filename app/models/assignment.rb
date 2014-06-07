class Assignment < ActiveRecord::Base
  has_many :homework_documents
  validates :deadline, presence: true

  scope :closed,   -> { where("deadline < ?", 1.day.ago) }
  scope :open,     -> { where("deadline > ?", 1.day.ago) }
  scope :graded,   -> { where(graded: true) }
  scope :ungraded, -> { where(graded: false) }

  def grader
    submitter_ids = "SELECT submitter_id FROM homework_documents
                     WHERE assignment_id = :assignment_id"
    Student.where("id IN (#{submitter_ids})", assignment_id: id)
  end
end
