class HomeworkDocument < ActiveRecord::Base
  belongs_to :grader, class_name: "Student"
  belongs_to :submitter, class_name: "Student"
  belongs_to :assignment

  before_save :calculate_penalty

  validates :assignment, presence: true

  private

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
    end
end
