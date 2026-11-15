#!/bin/bash
cd webapp
export RAILS_SERVE_STATIC_FILES=1
export PIDFILE=/tmp/rails.pid
export RAILS_ENV=production
export RAILS_PRODUCTION_DATABASE=production
export RAILS_LOG_TO_STDOUT=1
export RAILS_PRODUCTION_USERNAME=rails
export RAILS_PRODUCTION_PASSWORD=
export RAILS_SECRET_KEY_BASE=
export RAILS_BAD_WORDS_FILE=

./shell.sh -i -c "rails s"
