# Changelog

## 0.11.1 - 2016-05-05

* restyle task progress legend
* redirect lost nurse
* link to tasks page only for activated participants

## 0.11.0 - 2016-04-29

* add health centers for Brazil
* translate rest of Supervisor dashboard
* redirect non Supervisors from the Nurse Tasks page
* make links and buttons consistent in contrast
* reorganize tasks page layout
* update task date display; add home icon to brand
* consolidate Participant navigation menu
* add admin translations
* indicate a current lack of connectivity task
* move supervisor notes to sessions page
* redirect supervisor to sessions log
* display scheduled date of tasks in progress bar
* restrict editable Participant fields for Nurses
* update Nurse main page translations
* update display of Participant dates
* add version to dashboard

## 0.10.11 - 2016-04-19

* fix redirect from editing call to schedule final
* remove Messages (help requests) display
* scope Admin Device access by locale

## 0.10.10 - 2016-04-14

* update translation for "unassigned participant"
* redirect supervisor conditionally off contact form
* conditionally set User password
* add follow up call difficulties to timeline

## 0.10.9 - 2016-04-14

* add Portuguese translation for smartphone number
* add association to NurseTask to enable destruction
* translate "additional note"
* add Spanish translation for "unreleased"

## 0.10.8 - 2016-04-13

* remove next contact from 1, 3 wk follow ups
* update help message notification text
* add conditional cancel paths to contact point form
* translate Portuguese option groups
* update token_auth with translation change
* modify lesson completion calculation

## 0.10.7 - 2016-04-12

* apply more translations

## 0.10.6 - 2016-04-12

* apply numerous translations
* allow difficulties to be multiple select

## 0.10.5 - 2016-04-11

* enable Nurse Supervisor notes
* update participant timeline header text
* allow only nurses and supervisors to view tasks pg
* sort nurses by task status of active participants

## 0.10.4 - 2016-04-08

* change timeline link and page header text
* remove duplicate form option
* fix datatables translations
* fix datatables application
* add cancelled non-scheduled task response values

## 0.10.3 - 2016-04-07

* update termination language
* add nurse and enrollment date to dropped out table
* add participant name column
* add Spanish, Portuguese options
* add filtering and pagination for nurse supervisor

## 0.10.2 - 2016-04-07

* enable toggling of cancelled/rescheduled tasks
* update form seletions for supervisor session
* capture and display cancelled unscheduled contacts
* turn off confirm; add password in Rails admin

## 0.10.1 - 2016-04-07

* add options to supervision meeting topics
* reverse timeline of contacts
* Add pending participants for selenium fixtures
* capitalize "Additional contact" in all languages
* add associations to enable deletion
* remove Supervision Contact feature
* Update participant statuses in selenium fixtures
* remove Supervision Contact feature

## 0.10.0 - 2016-04-05

* allow supervisor to reassign nurse
* update participant workflow
* restyle admin dashboard (pending participants)
* remove admin landing page

## 0.9.6 - 2016-04-04

* update nokogiri
* patch uglifier gem
* update bit_core to patch redcarpet
* add placeholders for all scheduled tasks in bar
* move contact info to tasks page

## 0.9.5 - 2016-03-30

* fix translation for Additional contact
* show study id for cancelled tasks

## 0.9.4 - 2016-03-29

* allow Task viewing/editing in Rails admin
* redirect non-Nurses to root from dashboard
* fix contact supervisor bug
* update "Additional contact" text
* add color key to progress bar
* display cancelled tasks to Supervisor
* make Users confirmable
* update labels for smartphone

## 0.9.3 - 2016-03-29

* add user id to Sentry context
* add color coding key on main page
* make UI improvements for usability
* update progress + task color codes
* display additional contact l/r based on kind
* accept letters and numbers for smartphone
* add Participant id and name to header
* ensure Participants can be deleted

## 0.9.2 - 2016-03-29

* be more liberal when listing optional topics
* allow Supervisors to clear Notifications
* dissociate Notifications from Supervisors
* add active participant count
* display dropped out participants
* display completed participants to Supervisor

## 0.9.1 - 2016-03-28

* show detailed Participant data to Supervisor
* show overdue and current tasks for nurses
* display history of supervision meetings
* add supervision contact creation
* add supervision topic
* list current tasks; color supervisor sessions

## 0.9.0 - 2016-03-24

* enable supervision session logging
* display overview of each assigned Nurse
* change "Disqualify" to "Treatment termination"
* remove Ineligible tab on pending participants page
* update Cancel link for Nurse from Participant form
* show a notice instead of alert on completion

## 0.8.6 - 2016-03-23

* add translation for "disabled"

## 0.8.5 - 2016-03-23

* add column headings to Nurse main page

## 0.8.4 - 2016-03-23

* sort patients correctly by task status
* prevent non adherence task creation without nurse
* prevent help request task creation with no nurse
* show locales only to unauthenticated users
* add scheduled task cancellation form
* add all token page translations
* tidy up for rails admin

## 0.8.3 - 2016-03-22

* allow Nurses to edit Participant data
* sort logins in reverse chronological order

## 0.8.2 - 2016-03-22

* enable togglable Logins table
* calculate study day based on timezone
* order participants by tasks/dates
* assign pending participants correctly

## 0.8.1 - 2016-03-21

* make default_next_contact_at more pessimistic
* ensure Participant has Nurse for Connectivity Task
* update English translations for week 3 FU

## 0.8.0 - 2016-03-21

* finalize final appointment form
* finalize week 3 follow-up form
* finalize week one follow-up form
* serialize all Planned Activity attributes
* allow duplicate device with different Participants
* allow multiple start dates
* enable pullable resources filtered by date bound
* dissociate nurses from all but participants table
* remove nurse association from Additional Contact
* delete active non adherence tasks when invalidated
* add smartphone identifier to rails admin

## 0.7.2 - 2016-03-16

* when accessing completed Participant, show notice
* update Spanish text for "Pending participants"
* render notes on note form
* add non scheduled contacts to timeline
* remove old status bar; update bootstrap js
* display scheduled contacts and Notes under Notes

## 0.7.1 - 2016-03-16

* add default timestamps to scheduled appointments
* allow blank phone numbers
* redirect when lesson not found
* clean up and finalize first appointment form
* bump token_auth version with en translations
* remove smartphone phone_identifier default

## 0.7.0 - 2016-03-15

* translate token page
* translate "Clinical Summary"
* update change password email link and page styles
* fix copy/paste error in select choices
* update participant form, table, and validations

## 0.6.5 - 2016-03-14

* translate email and reset password page
* finish translations for alert forms
* add missing non adherence choices
* update lesson status colors and legend

## 0.6.4 - 2016-03-11

* display contact history by descending date
* add final call to contact details
* enable non scheduled task resolution

## 0.6.3 - 2016-03-10

* enable dynamic activity choices list

## 0.6.2 - 2016-03-09

* enable activity planning customization
* enable task rescheduling

## 0.6.1 - 2016-03-08

* complete participant when final aptmt complete
* add progress bar colors
* add tokens to nurse dashboard main page
* resolve tasks when associated form is completed

## 0.6.0 - 2016-03-07

* create task for lack of adherence call
* add 30 minute User session timeout
* remove remember me option
* display only due/overdue tasks
* update links between detailed / contact info pages

## 0.5.18 - 2016-03-04

* update lessons table display
* remove, reorder first appointment form fields
* update smartphone form
* prettify report page html and update note icon
* preserve participant note feature
* update confirmation call form

## 0.5.16 - 2016-03-03

* enable clearing of supervisor notifications
* display timestamp of last specific notification
* allow nurses to cancel scheduled tasks

## 0.5.15 - 2016-03-02

* add client timestamp columns

## 0.5.14 - 2016-03-01

* allow one active, multiple resolved alert tasks
* handle no existing supervisor notifications

## 0.5.12 - 2016-03-01

* add Confirm links to scheduled tasks
* remove status circle
* enable Admins to manage Devices
* remove sms notifications for participants, nurses
* display only active tasks in total count

## 0.5.11 - 2016-03-01

* update Clinical Summary link
* specify when a task was/will be assigned
* display only scheduled tasks in the progress bar
* display timestamp of last supervisor notification
* display overdue task styles and counts correctly
* do not require web font due to slow loading

## 0.5.10 - 2016-02-29

* patch Rails
* remove 7 day access count
* add confirmation to supervisor notification
* enable supervisor notification for tasks
* enable alert task resolve action

## 0.5.9 - 2016-02-29

* add task progress bar
* add clinical summary link from tasks page
* remove active participants page and related code
* display time since/until tasks

## 0.5.8 - 2016-02-26

* customize superuser super powers
* add additional contact creation for nurses
* link from tasks to participant page
* display tasks in chronological scheduled order

## 0.5.7 - 2016-02-25

* customize login list for Rails admin
* color code participant rows based on tasks
* add scheduled task to create connectivity alerts
* display task names on nurse dashboard main page
* add scheduled task to create connectivity alerts

## 0.5.6 - 2016-02-24

* observe and record payload fetch requests
* add help request task triggering

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
