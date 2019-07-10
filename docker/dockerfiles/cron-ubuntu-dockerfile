FROM ubuntu:18.04

# Needing bash to navigate inside of the container and executing commands
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
cron \
nano

# Making entry point available in the container, and making it executable
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod 777 docker-entrypoint.sh

# Starting cron as the entrypoint of this image
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/cron", "-f"]