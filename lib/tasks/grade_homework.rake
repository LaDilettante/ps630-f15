namespace :grading do
  desc "Assign homework to grader"
  task :assign => :environment do
    Assignment.closed.ungraded.each do |assignment|
      students = assignment.grader
      a = students.shuffle
      # a is the shuffled list of student. "Rotate" that by one position, we match each person to another
      # We zip together the unrotated and the rotated array, then convert to a hash
      grader_map_to_submitter = Hash[*a.zip(a.rotate(1)).flatten]

      grader_map_to_submitter.each do |grader, submitter|
        doc = submitter.submitted_homework_documents.where(assignment_id: assignment.id).last
        doc.update_attribute(:grader_id, grader.id)
      end
    end
  end

  desc "Notify grader that they have grading to do"
  task :notify => :environment do
    Assignment.closed.ungraded.each do |assignment|
      assignment.grader.each do |grader|
        GraderMailer.notify_pending_grading(grader, assignment)
      end
    end
  end

  desc "Assign grading and notify grader"
  task :all => [:assign, :notify]
end