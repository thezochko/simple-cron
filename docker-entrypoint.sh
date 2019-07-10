#!/bin/bash
set -e

#echo "Entry point script is now working !: ${CRONJOBS_TEXT_FILE_PATH_ENV}"

echo ${CRONJOBS_TEXT_FILE_PATH_ENV} | crontab -

# Lets check if the builder wants to use cronjobs file
#if [ ! -z "${CRONJOBS_TEXT_FILE_PATH_ENV}"]; then
    # Inserting the conjobs into the crontab
    # echo "HEY2" | crontab -
    #echo "The file path wehere the cronjobs are listed: ${CRONJOBS_TEXT_FILE_PATH_ENV}"
#fi

exec "$@"