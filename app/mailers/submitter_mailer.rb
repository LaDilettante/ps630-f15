class SubmitterMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify_available_grade(submitter, doc)
    @submitter = submitter
    @doc = doc
    @assignment  = doc.assignment
    mail(to: @submitter.email, subject: "Your grade for #{@assignment.title} is now available")
  end
end
