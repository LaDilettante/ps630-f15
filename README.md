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

## Setting up:

Local setup

1. `bundle install` > `bundle update`
2. `rake db:migrate` > `rake db:populate` (`db:populate` to populate database with mock data)

Heroku setup

1. `heroku create` > `git push heroku master` > `heroku rename new-name`
2. `heroku run rake db:migrate`
3. `heroku addons:create sendgrid`
    - change host in `config.action_mailer.default_url_options = { host: "polsci630.herokuapp.com" }`
4. `heroku addons:create scheduler`
    - Scheduling job: https://devcenter.heroku.com/articles/scheduler#scheduling-jobs
    - `rake remind_deadline`
    - `rake assign_grading`
5. `heroku addons:create newrelic`. `Settings > Availability Monitoring > Enter URL`

Site customization

1. Change site title: `application_helper.rb` > `def site_title`
2. Late penalty: `homework_document.rb` > `def calculate_penalty`

## Rails utility

- `Student.find_by(name: "Student 1").submitted_homework_documents.map(&:grade)`
- `heroku run logs -t`