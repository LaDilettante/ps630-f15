desc "This task is called by the Heroku scheduler add-on"
task :assign_grading => :environment do
  puts "Assigning grading..."
  Assignment.grade_all
  puts "done."
end

task :remind_deadline => :environment do
  puts "Sending email reminder about deadline..."
  Assignment.deadline_reminder
  puts "done."
end