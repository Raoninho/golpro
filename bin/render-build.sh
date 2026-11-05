#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate

if [ "${RUN_SEEDS_ON_DEPLOY:-0}" = "1" ]; then
  bin/rails db:seed
fi
