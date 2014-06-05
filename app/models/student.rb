class Student < User
  has_many :submitted_homework_documents, 
    foreign_key: "submitter_id", class_name: "HomeworkDocument" 
  has_many :returned_homework_documents,
    foreign_key: "grader_id", class_name: "HomeworkDocument"
end
