#!/bin/bash
set -e

docker compose up -d

# Remove server.pid file if it exists
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Install any missing gems
bundle check || bundle install

# Run database migrations and seed data
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

# Start Rails server in the background
bin/rails s -p 3000 -b 0.0.0.0 &

# Start Sidekiq in the background and save its PID to a file
bundle exec sidekiq & echo $! > tmp/pids/sidekiq.pid