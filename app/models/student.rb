class Student < ActiveRecord::Base
  has_many :submitted_homework_documents, 
    foreign_key: "submitter_id", class_name: "HomeworkDocument" 
  has_many :returned_homework_documents,
    foreign_key: "grader_id", class_name: "HomeworkDocument"

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
end
