class HomeworkDocument < ActiveRecord::Base
  belongs_to :grader, class_name: "Student"
  belongs_to :submitter, class_name: "Student"
  belongs_to :assignment, inverse_of: :homework_documents
  has_attached_file :ungraded_file
  has_attached_file :ungraded_file_source_code
  has_attached_file :graded_file
  has_attached_file :graded_file_source_code

  after_create :calculate_penalty

  validates :assignment, presence: true
  validates :submitter, presence: true
  validates :grade, numericality: true, allow_nil: true

  validates_attachment :ungraded_file, presence: true,
    size: { in: 0..10.megabytes }
  before_ungraded_file_post_process :set_ungraded_file_content_type

  validates_attachment :ungraded_file_source_code, presence: true,
    size: { in: 0..10.megabytes }

  validates_attachment :graded_file, 
    size: { in: 0..10.megabytes }
  before_graded_file_post_process :set_graded_file_content_type

  validates_attachment :graded_file_source_code,
    size: { in: 0..10.megabytes }



  def calculate_penalty
    time_late = created_at - assignment.deadline
    case
    when time_late < 0
      self.penalty = 0
    when time_late > 0 && time_late <= 1.day
      # After each 2 hours subtract 5%
      self.penalty = (time_late / 2.hours).to_i * 0.05
    when time_late > 1.day
      # Get a 0 when late for more than a day
      self.penalty = 1
    end
    save
  end

  def final_grade
    if grade.nil?
      return nil
    else
      return grade * (1 - penalty)
    end
  end

  def submitter?(user_id)
    self.submitter_id == user_id
  end

  def grader?(user_id)
    self.grader_id == user_id
  end

  private

    def set_ungraded_file_content_type
      self.ungraded_file.instance_write(:content_type, MIME::Types.type_for(self.ungraded_file_file_name).first.content_type.to_s)
    end

    def set_graded_file_content_type
      self.graded_file.instance_write(:content_type, MIME::Types.type_for(self.graded_file_file_name).first.content_type.to_s)
    end
end
