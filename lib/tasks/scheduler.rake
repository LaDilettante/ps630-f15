desc "Assign grading, run by Heroku scheduler"
task :assign_grading => :environment do
  puts "Assigning grading..."
  Assignment.grade_all
  puts "done."
end

desc "Remind assignment deadline, run by Heroku scheduler"
task :remind_deadline => :environment do
  puts "Sending email reminder about deadline..."
  Assignment.deadline_reminder
  puts "done."
end