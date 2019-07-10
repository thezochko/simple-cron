#!/bin/bash
set -e

# We dont want to use the single cronjob if theres a predefined file with the cronjobs
cronJobsfileExist=false
directory=/docker-entrypoint-initcron.d/

if [ -d "${directory}" ]; then
    for file in ${directory}*; do
        cronJobsfileExist=TRUE
        # Inserting the conjobs from file into the crontab
        cat "${file}" | crontab -
    done
fi

# Lets check if the creator wants to use a single cronjob
if [ "${cronJobsfileExist}" = false ]; then
    # Inserting the conjob into the crontab
    echo "${CRONJOB}" | crontab -
fi

exec "$@"