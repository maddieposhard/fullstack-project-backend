#!/usr/bin/env bash
# exit on error
set -o errexit
cd books_api
bundle install
bundle exec rake db:migrate