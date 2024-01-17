#!/bin/bash

echo "Deploying to Staging..."

APP_NAME="getbooked"
REMOTE_USER="ec2-user"
REMOTE_HOST="44.199.170.53"
REPO_URL="https://github.com/StepanBoiko/getbooked.git"
BRANCH="master"

# Clone or pull the latest code from the repository
ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir remotetestdir"
ssh ${REMOTE_USER}@${REMOTE_HOST} "cd remotetestdir"
ssh ${REMOTE_USER}@${REMOTE_HOST} "git clone https://github.com/StepanBoiko/getbooked.git"
# ssh ${REMOTE_USER}@${REMOTE_HOST} "git clone ${REPO_URL} -b ${BRANCH} --single-branch --depth 1 ${APP_NAME} || (cd ${APP_NAME} && git pull)"

# # Change to the application directory
# ssh ${REMOTE_USER}@${REMOTE_HOST} "cd ${APP_NAME}"

# # Install dependencies and run migrations
# ssh ${REMOTE_USER}@${REMOTE_HOST} "cd ${APP_NAME} && bundle install --without development test && rake db:migrate"

# # Restart the application server (replace with your actual server restart command)
# ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo systemctl restart your_rails_app.service"


echo "Deployment to staging completed successfully."

