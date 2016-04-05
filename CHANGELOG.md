# Changelog

## 0.2.8 - 2016-04-06

* remove debug log functionality
* patch nokogiri gem
* patch uglifier gem
* update bit_core to patch redcarpet

## 0.2.6 - 2016-02-29

* patch Rails

## 0.2.5 - 2016-02-18

* create special branch+tag for field trial dashboard deployment

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
