#!/bin/bash

  bundle exec rake log:clear LOGS=all
  for i in 1 $(seq 20); do
    echo "== $i-th test"

    rand=$(< /dev/urandom tr -dc A-Za-z-0-9 | head -c${1:-4})
    log_file=tmp/rake-test-$(date +"%Y%m%d-%H%M%S-$rand").out
    PARALLEL_WORKERS=1 bundle exec rake test 2>&1 | tee $log_file

    if tail $log_file | grep '0 failures, 0 errors,'; then
      echo 'ok'
    else
      echo 'bad!'
      break
    fi
  done

  # save error-ed test.log
  cp log/test.log log/test.log-$(date +"%Y%m%d-%H%M%S")
