# Que Degradation Test

A simple test designed to test Que's performance under highly degraded conditions.

The metric format is currently designed to emit to Librato via logging to standard out. This can be accomplished by adding the Librato add-on to a Heroku app which will create a log drain.

The basic steps to reproduce a degraded situation are as follows:

1. Perform the installation as detailed below.
2. Start a producer and a worker to produce some churn on the jobs table. Verify that the job queue is able to maintain a steady state under normal conditions.
3. Start up the "longrunner" process. This will open a transaction, perform a write, and sleep for an extended period of time, which should allow you to easily observe Que's degraded state after a short period (under default conditions, it may take a few minutes for it to fully degrade).

## Local Install

```
$ bundle install
$ createdb que-degradation-test
$ bundle exec sequel -m migrations/ postgres://localhost/que-degradation-test

# start a producer
$ DATABASE_URL=postgres://localhost/que-degradation-test bundle exec bin/producer

# start a worker
$ DATABASE_URL=postgres://localhost/que-degradation-test bundle exec bin/worker

# start a long runner
$ DATABASE_URL=postgres://localhost/que-degradation-test bundle exec bin/long-runner
```

## Heroku Install

```
$ heroku create
$ heroku addons:add heroku-postgresql:standard-0
$ heroku run 'bundle exec sequel -m migrations/ $DATABASE_URL'

# start a producer and worker
$ heroku ps:scale producer=1 worker=1

# start a long runner
$ heroku ps:scale longrunner=1
```
