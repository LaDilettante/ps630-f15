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

  def notify_closing_deadline(student, assignment)
    @student = student
    @assignment = assignment
    mail(to: @student.email, subject: "Reminder: Assignment deadline in 1 day")
  end

  def notify_pending_grading(grader, assignment)
    @grader = grader
    @assignment = assignment
    mail(to: @grader.email, subject: "There is someone's homework waiting for you")
  end

  def notify_available_comment(submitter, doc)
    @submitter = submitter
    @doc = doc
    @assignment  = doc.assignment
    mail(to: @submitter.email, subject: "Comments for #{@assignment.title} is now available")
  end

  def notify_available_grade(submitter, doc)
    @submitter = submitter
    @doc = doc
    @assignment  = doc.assignment
    mail(to: @submitter.email, subject: "Your grade for #{@assignment.title} is now available")
  end

  def notify_new_assignment(assignment, user)
    @assignment = assignment
    @user = user
    mail(to: user.email, subject: "New assignment posted")
  end

  def notify_new_meeting(meeting, user)
    @meeting = meeting
    @user = user
    mail(to: user.email, subject: "New meeting material posted")
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "Your polsci630 account requested a password reset")
  end

  def notify_successful_password_reset(user)
    @user = user
    mail(to: user.email, subject: "The password of your polsci630 account has been reset")
  end
end
