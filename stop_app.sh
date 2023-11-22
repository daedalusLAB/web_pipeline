#!/bin/bash
set -e

cd "$(dirname "$0")"
source .env

if [ -z "$PASSENGER_ENABLED" ]; then
    # Send the SIGTERM signal to the Rails server
    if [ -f tmp/pids/server.pid ]; then
        echo "Stopping Rails server"
        kill $(cat tmp/pids/server.pid)
    fi
fi

# Send the SIGTERM signal to Sidekiq using the PID saved in the file
if [ -f tmp/pids/sidekiq.pid ]; then
    echo "Stopping Sidekiq"
    kill $(cat tmp/pids/sidekiq.pid)
    rm -f tmp/pids/sidekiq.pid
fi
# Wait for the processes to stop
sleep 10

if [ -z "$PASSENGER_ENABLED" ]; then
    # if file tmp/pids/server.pid exists, kill the process
    if [ -f "tmp/pids/server.pid" ]; then
        echo "Force stopping Rails server"
        kill -9 $(cat tmp/pids/server.pid)
        rm -f tmp/pids/server.pid
    fi
fi
# if file tmp/pids/sidekiq.pid exists, kill the process
if [ -f tmp/pids/sidekiq.pid ]; then
    echo "Force stopping Sidekiq"
    kill -9 $(cat tmp/pids/sidekiq.pid)
    rm -f tmp/pids/sidekiq.pid
fi

docker compose stop


