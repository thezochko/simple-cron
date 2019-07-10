#!/bin/bash
set -e

# We dont want to use the single cronjob if theres a predefined file with the cronjobs
cronJobsfileExist=FALSE

for file in /docker-entrypoint-initcron.d/*; do
    fileExist=TRUE
    # Inserting the conjobs from file into the crontab
    cat "${file}" | crontab -
done

# Lets check if the creator wants to use a single cronjob
if [ ! -z "${CRONJOB}"] || ["${cronJobsfileExist}" = FALSE]; then
    # Inserting the conjob into the crontab
    cat ${CRONJOB} | crontab -
fi

exec "$@"