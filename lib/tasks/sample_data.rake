namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    FactoryGirl.create(:teacher, name: "teacher", email: "teacher@teacher.com")
    FactoryGirl.create(:student, name: "student", email: "student@student.com")
    5.times { FactoryGirl.create(:student) }
    7.times { FactoryGirl.create(:assignment) }
    Student.all.each do |student|
      Assignment.all.each do |assignment|
        student.submitted_homework_documents.create(
          content: Faker::Lorem.sentence(2),
          assignment_id: assignment.id,
          created_at: assignment.deadline + rand(-1.day..1.day),
          ungraded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"),
          ungraded_file_source_code: File.open(Rails.root + "spec/fixtures/documents/lab1.tex") )
      end
    end
  end

  desc "Grade the first student (sample data)"
  task :grade_first_student => :environment do
    Student.first.submitted_homework_documents.each do |doc|
      doc.update_attribute(:grade, rand(100))
    end
  end
end