#!/bin/bash

# Run database migrations
bundle exec rails db:migrate

# Precompile assets
bundle exec rails assets:precompile

# Start the Rails server
exec "$@"
