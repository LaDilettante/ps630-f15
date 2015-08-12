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
  
  validate :grade_smaller_than_max_grade, on: :update

  validates_attachment :ungraded_file, presence: true,
    size: { in: 0..10.megabytes }
  # before_ungraded_file_post_process :set_ungraded_file_content_type

  validates_attachment :ungraded_file_source_code, presence: true,
    size: { in: 0..10.megabytes }

  validates_attachment :graded_file, 
    size: { in: 0..10.megabytes }
  # before_graded_file_post_process :set_graded_file_content_type

  validates_attachment :graded_file_source_code,
    size: { in: 0..10.megabytes }

  validate :grader_submitting_graded_file, on: :update, if: :current_user_is_grader?

  scope :ungraded, -> { where("grade is NULL") }
  scope :graded,   -> { where("grade IS NOT NULL") }
  scope :uncommented, -> { where("graded_file_file_name IS NULL") }
  scope :commented,   -> { where("graded_file_file_name IS NOT NULL") }

  def calculate_penalty
    time_late = created_at - assignment.deadline
    case
    # use update_attribute to bypass on: :update validation
    when time_late < 0
      # update_attribute(:penalty, 0)
      self.penalty = 0
    when time_late > 0 && time_late <= 1.day
      # After 1 day subtract 1 letter grade (3 pts out of 16)
      self.penalty = 3
    when time_late > 1.day && time_late <= 2.days
      # After 2 days subtract 2 letter grade (6 pts out of 16)
      self.penalty = 6
    when time_late > 2.days
      # Over 2 days, subtract all points
      self.penalty = assignment.max_grade
    end
    save!
  end

  def final_grade
    if grade.nil?
      return nil
    else
      return grade - penalty
    end
  end

  def submitter?(user_id)
    self.submitter_id == user_id
  end

  def grader?(user_id)
    self.grader_id == user_id
  end

  def current_user_is_grader?
    !grader_id.nil? && grader?(user_id)
  end

  private

    def set_ungraded_file_content_type
      self.ungraded_file.instance_write(:content_type, MIME::Types.type_for(self.ungraded_file_file_name).first.content_type.to_s)
    end

    def set_graded_file_content_type
      self.graded_file.instance_write(:content_type, MIME::Types.type_for(self.graded_file_file_name).first.content_type.to_s)
    end

    def grade_smaller_than_max_grade
      if !user_id.nil? && grader?(user_id) && !grade.nil? && grade > assignment.max_grade
        errors.add(:grade, "can't be greater than the assignment's max grade")
      end
    end

    def grader_submitting_graded_file
      # From controller: @doc.user_id = current_user.id
      if grader?(user_id)
        if graded_file_file_name.nil?
          errors.add(:graded_file, "must be uploaded. Your peer would appreciate your feedback")
        end

        if graded_file_source_code_file_name.nil?
          errors.add(:graded_file_source_code, "must be uploaded. Your peer would appreciate your feedback")
        end
      end
    end
end
