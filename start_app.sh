#!/bin/bash
set -e

cd "$(dirname "$0")"
source .env

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

# if env variable PASSENGER_SUBFOLDER is set, then we are using passenger
# so dont start rails server, just sidekiq
if [ -z "$PASSENGER_ENABLED" ]; then
  # Start Rails server in the background
  echo "Starting Rails server"
  bin/rails s -p 3000 -b 0.0.0.0 &
fi

# Start Sidekiq in the background and save its PID to a file
echo "Starting Sidekiq"
bundle exec sidekiq start

