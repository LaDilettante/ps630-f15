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

  def self.grade_all
    closed.ungraded.each do |assignment|
      assignment.assign_homework_doc_to_grader  
    end
  end

  def assign_homework_doc_to_grader
    students = grader
    a = students.shuffle
    # a is the shuffled list of student. "Rotate" that by one position, we match each person to another
    # We zip together the unrotated and the rotated array, then convert to a hash
    grader_map_to_submitter = Hash[*a.zip(a.rotate(1)).flatten]

    grader_map_to_submitter.each do |grader, submitter|
      doc = submitter.submitted_homework_documents.where(assignment_id: id).last
      doc.update_attribute(:grader_id, grader.id)
      GraderMailer.notify_pending_grading(grader, self)
    end
    update_attribute(:graded, true)
  end
end
