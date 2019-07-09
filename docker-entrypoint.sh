#!/bin/bash
set -e

echo "Entry point script is now working !"

apk add php7

if [ ! -z ${CRON_JOB_DEPENDENCIES_ARG}]; then
    export ${CRON_JOB_DEPENDENCIES}=${CRON_JOB_DEPENDENCIES_ARG}
    echo "The package to install is: ${CRON_JOB_DEPENDENCIES}"
fi

exec "$@"