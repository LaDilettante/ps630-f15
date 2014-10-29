### My Teaching Assistant App

## Models
1. There are two kinds of `Users` (using Single Table Inheritance) -- `Student` and `Teacher`
2. `Assignment`: has_many `homework_documents`
* Import attributes: `deadline`
3. `HomeworkDocument`: belongs_to `grader` and `submitter`, both of which are class `Student`
* Important attributes: `grade`, `created_at`, `penalty`

## Main functions:

1. Randomly send out submitted homework to graders
  * Console: `Assignment.grade_all`
  * Select all assignment that is not closed and graded, then send out randomly to a pool of graders. The pool of graders are the students who have submitted their homework for that assignment
  * Use Heroku scheduler to run `Assignment.grade_all` every 1 hour

2. Automatically calculate penalty on late submission. Details in `app/models/homework_document.rb`.

3. Mailer automatically notify students of available grades and pending deadlines
  * Using `SendGrid` on `heroku`. Current email address: `teachingassistant.app@gmail.com`

## Add-ons:
* Email: SendGrid
* Ping to keep dyno live: NewRelic
