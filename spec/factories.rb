FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}"}
    sequence(:email) { |n| "user_#{n}@example.com" }
  end

  factory :student do
    sequence(:name) { |n| "Student #{n}" }
    sequence(:email) { |n| "student_#{n}@example.com" }
  end

  factory :homework_document do
    content Faker::Lorem.sentence(3)
  end

  factory :assignment do
    sequence(:title) { |n| "Assignment #{n} title" }
    sequence(:body) { |n| "Assignment #{n} body" }
    sequence(:deadline) { |n| n.weeks.ago }
  end
end