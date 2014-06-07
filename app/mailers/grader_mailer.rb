class GraderMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify_pending_grading(grader, assignment)
    @grader = grader
    @assignment = assignment
    mail(to: @grader.email, subject: "There is someone's homework waiting for you")
  end
end
