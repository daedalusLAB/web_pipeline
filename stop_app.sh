#!/bin/bash
set -e

# Send the SIGTERM signal to the Rails server
if [ -f tmp/pids/server.pid ]; then
    echo "Stopping Rails server"
    kill -SIGTERM $(cat tmp/pids/server.pid)
fi

# Send the SIGTERM signal to Sidekiq using the PID saved in the file
if [ -f tmp/pids/sidekiq.pid ]; then
    echo "Stopping Sidekiq"
    kill -SIGTERM $(cat tmp/pids/sidekiq.pid)
    rm -f tmp/pids/sidekiq.pid
fi
# Wait for the processes to stop
sleep 10

# if file tmp/pids/server.pid exists, kill the process
if [ -f "tmp/pids/server.pid" ]; then
    echo "Force stopping Rails server"
    kill -9 $(cat tmp/pids/server.pid)
    rm -f tmp/pids/server.pid
fi

# if file tmp/pids/sidekiq.pid exists, kill the process
if [ -f tmp/pids/sidekiq.pid ]; then
    echo "Force stopping Sidekiq"
    kill -9 $(cat tmp/pids/sidekiq.pid)
    rm -f tmp/pids/sidekiq.pid
fi

docker compose stop


