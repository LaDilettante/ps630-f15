namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    FactoryGirl.create(:teacher, name: "teacher", email: "teacher@teacher.com")
    FactoryGirl.create(:student, name: "student", email: "student@student.com")
    5.times { FactoryGirl.create(:student) }
    3.times { FactoryGirl.create(:assignment) }
    Student.all.each do |student|
      Assignment.all.each do |assignment|
        student.submitted_homework_documents.create(
          content: Faker::Lorem.sentence(2),
          assignment_id: assignment.id,
          created_at: rand(-1.month..1.month).ago)
      end
    end
  end
end