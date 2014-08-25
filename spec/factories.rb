FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}"}
    sequence(:email) { |n| "user_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end


  factory :student do
    sequence(:name)  { |n| "Student #{n}" }
    sequence(:email) { |n| "student_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :teacher do
    sequence(:name)  { |n| "Teacher #{n}" }
    sequence(:email) { |n| "teacher_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :homework_document do
    content Faker::Lorem.sentence(3)
    ungraded_file File.open(Rails.root + "spec/fixtures/documents/lab1.pdf")
  end

  factory :assignment do
    sequence(:title) { |n| "Assignment #{n} title" }
    sequence(:body) { |n| "Assignment #{n} body" }
    sequence(:deadline) { |n| 1.year.ago + n.weeks }
    max_grade 100
    sequence(:graded) { false }
    document { File.open(Rails.root + "spec/fixtures/documents/lab1.pdf") }
    source_code { File.open(Rails.root + "spec/fixtures/documents/lab1.tex") }
  end
end