FactoryGirl.define do
  factory :student do
    sequence(:name) { |n| "Student #{n}"}
    sequence(:email) { |n| "student_#{n}@example.com" }
  end

  factory :homework_document do
    content Faker::Lorem.sentence(2)
  end

  factory :assignment do
    sequence(:title) { |n| "Assignment #{n} title" }
    sequence(:body) { |n| "Assignment #{n} body" }
  end
end