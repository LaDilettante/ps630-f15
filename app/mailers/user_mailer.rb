class UserMailer < ActionMailer::Base
  default from: "teachingassistant.app@gmail.com"
  helper ApplicationHelper

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Thank you for signing up")
  end

  def notify_setting_change(user)
    @user = user
    mail(to: @user.email, subject: "Your profile setting has been changed")
  end

  def notify_pending_grading(grader, assignment)
    @grader = grader
    @assignment = assignment
    mail(to: @grader.email, subject: "There is someone's homework waiting for you")
  end

  def notify_available_grade(submitter, doc)
    @submitter = submitter
    @doc = doc
    @assignment  = doc.assignment
    mail(to: @submitter.email, subject: "Your grade for #{@assignment.title} is now available")
  end

  def notify_new_meeting(meeting)
    @meeting = meeting
    Student.all.each do |student|
      @student = student
      mail(to: student.email, subject: "New meeting material posted")
    end
  end
end
