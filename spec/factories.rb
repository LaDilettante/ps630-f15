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
    ungraded_file File.open(Rails.root + "spec/fixtures/documents/midterm2_360.pdf")
  end

  factory :assignment do
    sequence(:title) { |n| "Assignment #{n} title" }
    sequence(:body) { |n| "Assignment #{n} body" }
    sequence(:deadline) { |n| n.weeks.ago }
    sequence(:graded) { |n| n % 2 == 0 }
  end
end