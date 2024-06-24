#!/bin/sh
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle check || bundle install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

exec "$@"
