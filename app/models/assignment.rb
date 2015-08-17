class Assignment < ActiveRecord::Base
  has_many :homework_documents, inverse_of: :assignment
  has_attached_file :document
  has_attached_file :source_code
  has_attached_file :solution
  has_attached_file :solution_source_code
  validates :deadline, presence: true
  validates :title, presence: true, allow_blank: false

  validates_attachment :document, presence: true,
    size: { in: 0..10.megabytes }
  before_document_post_process :set_document_content_type

  validates_attachment :source_code, presence: true,
    size: { in: 0..10.megabytes }

  validates_attachment :solution,
    size: { in: 0..10.megabytes }
  before_solution_post_process :set_solution_content_type

  validates_attachment :solution_source_code,
    size: { in: 0..10.megabytes }

  scope :closed,   -> { where("deadline < ?", 2.days.ago) }
  scope :open,     -> { where("deadline > ?", 2.days.ago) }
  scope :graded,   -> { where(graded: true) }
  scope :ungraded, -> { where(graded: false) }

  def grader
    submitter_ids = "SELECT submitter_id FROM homework_documents
                     WHERE assignment_id = :assignment_id"
    Student.where("id IN (#{submitter_ids})", assignment_id: id)
  end

  def Assignment.deadline_reminder
    open.each do |assigment|
      if Time.zone.now > assignment.deadline - 1.day
        Student.all.each do |student|
          unless student.submitted_homework_documents.map(&:assignment_id).include? assignment.id
            UserMailer.notify_closing_deadline(student, assignment).deliver!
          end
        end 
      end
    end
  end

  def Assignment.grade_all
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
      UserMailer.notify_pending_grading(grader, self).deliver!
    end
    update_attribute(:graded, true)
  end

  private

    def set_document_content_type
      self.document.instance_write(:content_type, MIME::Types.type_for(self.document_file_name).first.content_type.to_s)
    end

    def set_solution_content_type
      self.solution.instance_write(:content_type, MIME::Types.type_for(self.solution_file_name).first.content_type.to_s)
    end
end
