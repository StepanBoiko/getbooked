#!/bin/bash

echo "Deploying to Staging..."


APP_DIR="/path/to/your/app"
RAILS_ENV="staging"

cd $APP_DIR

# Fetch the latest changes from the repository
git pull origin main

# Install or update dependencies
bundle install --deployment --without development test

# Run database migrations
RAILS_ENV=$RAILS_ENV bundle exec rake db:migrate

# Precompile assets
RAILS_ENV=$RAILS_ENV bundle exec rake assets:precompile

# Restart the application server
sudo systemctl restart your-app-staging.service

echo "Deployment to staging completed successfully."

