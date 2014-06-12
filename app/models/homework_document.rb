class HomeworkDocument < ActiveRecord::Base
  belongs_to :grader, class_name: "Student"
  belongs_to :submitter, class_name: "Student"
  belongs_to :assignment, inverse_of: :homework_documents
  has_attached_file :ungraded_file
  has_attached_file :graded_file

  after_create :calculate_penalty

  validates :assignment, presence: true
  validates :submitter, presence: true
  validates :grade, numericality: true, allow_nil: true

  validates_attachment :ungraded_file, presence: true,
    content_type: { content_type: ["application/pdf"] ,
                    message: "only msword, pdf, tex files" },
    size: { in: 0..10.megabytes }

  validates_attachment :graded_file, 
    size: { in: 0..10.megabytes },
    content_type: { content_type: "/^application\/(msword|pdf|x-tex)/" ,
                     message: "only msword, pdf, tex files" }

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
    grade * (1 - penalty)
  end 
end
