# Que Degradation Test

A simple test designed to test Que's performance under highly degraded conditions.

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

```
$ heroku create
$ heroku addons:add heroku-postgresql:standard-0
$ heroku run 'bundle exec sequel -m migrations/ $DATABASE_URL'

$ heroku ps:scale producer=1 worker=1

$ heroku ps:scale longrunner=1
```
