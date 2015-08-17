namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    FactoryGirl.create(:teacher, name: "teacher", email: "teacher@teacher.com")
    FactoryGirl.create(:student, name: "student", email: "student@student.com")
    5.times { FactoryGirl.create(:student) }
    7.times { FactoryGirl.create(:assignment) }
    Student.all.each do |student|
      Assignment.all.each do |assignment|
        hw = student.submitted_homework_documents.create!(
          content: Faker::Lorem.sentence(2),
          assignment_id: assignment.id,
          created_at: assignment.deadline + rand(-1.day..1.day),
          ungraded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"),
          ungraded_file_source_code: File.open(Rails.root + "spec/fixtures/documents/lab1.tex"))
      end
    end

    # Assignments that students have not submitted
    1.times { FactoryGirl.create(:assignment, deadline: 1.day.from_now) } 
    1.times { FactoryGirl.create(:assignment, deadline: 2.day.from_now) } 
  end

  desc "Grade the first student (sample data)"
  task :grade_first_student => :environment do
    max_grade = 16
    Student.first.submitted_homework_documents.each do |doc|
      doc.update_attribute(:grade, rand(max_grade))
    end
  end

  desc "Comment the first student (sample data)"
  task :comment_first_student => :environment do
    Student.first.submitted_homework_documents.each do |doc|
      doc.update!(
          graded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"),
          graded_file_source_code: File.open(Rails.root + "spec/fixtures/documents/lab1.tex"))
    end
  end
end