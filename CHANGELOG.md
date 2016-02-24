# Changelog

## 0.5.5 - 2016-02-24

* add Nurse dashboard view
* add final appointment task
* add call to schedule final appointment task
* add follow up call week one task

## 0.5.4 - 2016-02-21

* auto create config tokens for new participants

## 0.5.3 - 2016-02-21

* change pencil icon to we chat
* display config tokens on nurse dashboard
* add app_version column to logins
* capture and forward JS exceptions to Sentry

## 0.5.2 - 2016-02-19

* fix broken token management link

## 0.5.1 - 2016-02-18

* destroy dependent records with Participant
* leave config token valid for 4 weeks
* redirect and notify of unauthorized requests
* update login locale behavior

## 0.5.0 - 2016-02-17

* display correct locale once authenticated
* deploy with Ruby 2.3.0
* add alerts to layouts
* show pending participants on nurse supervisor dash
* use already included FA stylesheets, not CDN
* add Superuser role will all permissions
* authorize based on records, not classes

## 0.4.6 - 2016-02-15

* update Rails admin for clearer presentation
* remove PRW related code and specs
* update Nurse and Nurse Supervisor permissions

## 0.4.5 - 2016-02-11

* allow admins to manage dialogues
* add recoverable option for Users

## 0.4.3 - 2016-02-11

* update Participant management permissions
* enable Nurse and NurseSupervisor management
* update authorization and specs accordingly

## 0.4.2 - 2016-02-08

* stop dumping pr debug log files
* capture responses to session forms

## 0.4.1 - 2016-02-05

* add link to token configuration

## 0.4.0 - 2016-02-02

* show PlannedActivities in Rails admin, add assoc.
* fix badly named column
* add hasActivityPlanning to Lesson JSON
* add PlannedActivities to sync API
* patch Rails
* add missing validation
* include all synced models in Rails admin views
* add has activity planning option to Lessons
* sync logins
* sync lesson events
* add missing validation to HelpMessage
* make synchronizable ParticipantStartDates
* sync help messages
* bump sentry-raven version
* incorporate TokenAuth and make Devices syncable
* update RuboCop compatibility with version 0.36
* update rails admin gem and styles

## 0.3.1 - 2015-12-11

* prevent null timezone attribute for Users
* prevent timeline popovers from toggling
* remove :participant_id from permitted attributes
* move routes above participants namespace
* add version route

## 0.3.0 - 2015-12-07

* redirect unknown GET and POST requests
* ignore invalid auth token exceptions
* ignore Net::OpenTimeout
* update to patched version of twilio-ruby gem
* add release version to Raven config
* increase data integrity of SessionEvents
* enforce data integrity of Responses
* protect data integrity for Logins
* make data integrity updates to ContentAccessEvent
* improve data integrity for HelpMessages
* update gem versions
* update and fix other Lesson-related code

## 0.2.3 - 2015-09-22

* add 'accessed' display to dashboard

## 0.2.2 - 2015-09-19

* count all lesson accesses separately

## 0.2.1 - 2015-09-10

* reset font sizes

## 0.2.0 - 2015-09-08

* replace SMS text
* display accessed sessions on the dashboard
* import session event data from PRW

## 0.1.14 - 2015-09-03

* capture and save PR debug logs to the file system

## 0.1.13 - 2015-09-03

* increase font sizes to 20px

## 0.1.12 - 2015-09-02

* update column headings
* update final appointment SMS content
* increase font size

## 0.1.11 - 2015-08-14

* increase font sizes, make minor html adjustment
* update jquery-rails with security patch

## 0.1.10 - 2015-07-26

* revamp exception reporting

## 0.1.9 - 2015-07-23

* add missing select2 image asset
* fix brittle dialogues table partial

## 0.1.8 - 2015-07-23

* fix and test brittle partial active participants lessons table
* bump rspec gem versions
* remove database_cleaner and speed specs by 75%

## 0.1.7 - 2015-07-22

* ensure #lesson_released? works for all cases
* make the Capybara RSpec matcher warnings disappear
* update select2 css to use digest asset paths
* redirect requests to third_contact#show
* add asterisk to all required input labels
* ensure all model exports include a locale and study_identifier
* update Travis and Brakeman config

## 0.1.6 - 2015-06-18

* Update rails and rack.

## 0.1.5 - 2015-06-04

* add local db table backed models to Rails Admin

## 0.1.4 - 2015-05-14

* fix broken controller and add spec
* remove fixtures corresponding to PRW data table

## 0.1.3 - 2015-05-13

* fix permitted parameters for third contacts
* ignore unrecognized request exceptions
* update Raven-Ruby gem

## 0.1.2 - 2015-05-12

* fix permitted parameters for first appointments
* add missing select2 image assets
* flesh out seed task
* improve spec coverage accuracy

## 0.1.1 - 2015-04-27

* update Ruby to 2.2.2
* update safe_yaml to compatible version
* update rubocop patch level

## 0.1.0 - 2015-04-09

* initial tagged release
