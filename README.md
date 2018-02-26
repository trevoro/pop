# README

## What is Pop?

People-On-Projects (PoP) is a high-level effort tracking application that provides week-over-week visibility into the work done by large software engineering teams.

Pop answers the following questions:

1. What products and objectives did all teams spend time on over the past week, month, quarter and year?

2. How many people have been working on each team over time?

3. What JIRA Issues (usually Epics) did the software engineering team work on in any given week?

4. What did the team ship last week?

5. How much of the team's capacity was allocated towards customer facing value vs. technical debt, build pipelines and other non-customer facing work.

Answers to these questions give teams, leaders and executives audit-able visibility into the costs associated with shipping product initiatives and the relative investments in team and product. This helps inform future effort allocation by providing insight into where past investment of effort has yielded the best results.

## Key Features

* **JIRA Integration**: PoP integrates with JIRA to enable weekly imports by JIRA filter or issue ID

* **In-place Editing** PoP supports in-place editing for rapid augmentation of imported JIRA data

* **Visual Reporting** PoP comes with a variety of visual reports that display what teams have worked on over time.

* **Weekly Summaries** PoP provides an easy way for team leaders to drop in weekly Markdown formatted notes about what their teams worked on. These can be used to generate weekly summaries of an entire engineering organization's work or a week over week history of a what a specific team has worked on over time.

* **Google Sign-In**: PoP implements Google Sign-In to optionally enable better application security and audit logging

## Documentation

* This README contains most of the current documentation. Some additional supporting documentation is available at [https://hootsuite.github.io/pop/](https://hootsuite.github.io/pop/)

## Installation Pre-Requisites

* Docker
* Docker Compose

## Installation

To get your development environment up and running:

1. Clone this repository

2. Switch to the root repo directory

```
$ cd pop
```

3. Build docker images for the web server & database

```
$ docker-compose build
```

4. Create a database configuration file

```
$ cp config/database.yml.sample config/database.yml
```

5. Create a database

```
$ docker-compose run web rake db:create
```

6. Set up the database schema
    
```
$ docker-compose run web rake db:migrate
```

## Runtime


To run the application, start the docker images and mount the application file system

```
$ docker-compose up
```

Your version of the app should now be visible at: http://localhost:3000

## Running tests

To run tests on the Docker image:

```
$ docker-compose run web bin/rails test
```

## Application Architecture

* Pop is a simple Ruby on Rails 5.0 application that runs on top of a MySQL database. The app and the database both run in their own Docker container.
