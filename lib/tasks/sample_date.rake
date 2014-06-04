namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    99.times { FactoryGirl.create(:student) }
  end
end