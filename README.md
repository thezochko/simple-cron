# Simple Cron 

[alpine3.10.0](https://github.com/thezochko/simple-cron/tree/master) - 5 MB
[alpine3.9](https://github.com/thezochko/simple-cron/tree/master) - 5 MB
[ubuntu18.04](https://github.com/thezochko/simple-cron/tree/master) - 49 MB

This image is designed to help setting up a cron container alot easier.
You will have crontab available out of the box.
And you will be able to implement cronjob/cronjobs in two different ways when using this image.

## So what you need to do

### One of two things:

##### NOTE:
We will be using docker-compose.yml to setup the image for build

Docker-compose.yml EXAMPLE file wich includes all options for setup, where you DONT need any packages installed to run the cronjobs:

> (In this case only the cronjobs inside of the volume containing a text with the cronjobs will be used, if you leave the volume out, the environment variable will be used instead)

```
version: '3'

services:
  cron:
    image: thezochko/simple-cron:alpine3.10.0
    environment:
      CRONJOB: "* * * * * echo 'hey' >> /test.txt"
    volumes:
      - "./docker/docker-entrypoint-initcron.d:/docker-entrypoint-initcron.d/"
```

Docker-compose.yml EXAMPLE file wich includes all options for setup, where you DO need packages installed to run the cronjobs:

> (In this case only the cronjobs inside of the volume containing a text with the cronjobs will be used, if you leave the volume out, the environment variable will be used instead)

```
version: '3'

services:
  cron:
    build:
        context: .
        dockerfile: Dockerfile
    environment:
      CRONJOB: "* * * * * echo 'hey' >> /test.txt"
    volumes:
      - "./docker/docker-entrypoint-initcron.d:/docker-entrypoint-initcron.d/"
```
When using this approach you will have to define your own Dockerfile (descripted below) wich extends the base image of your choice.

### 1 .
Create a volume with the name of "docker-entrypoint-initcron.d/" on your container site

```
volumes:
      - "./docker-entrypoint-initcron.d:/docker-entrypoint-initcron.d/"
```

What you call it on the host site we dont care about.
But we need to have a file "cronjobs.txt" (or whatever you call it) where all of your cronjobs are listed.

```
* * * * echo "example cronjob" >> /cronjob_lob1.txt 2>&1
* * * * echo "example cronjob" >> /cronjob_lob2.txt 2>&1
* * * * echo "example cronjob" >> /cronjob_lob3.txt 2>&1
```

### 2 .
You only need one cronjob running inside of the container?
Then provide enviornment variable: 

```
environment:
    CRONJOB: '* * * * * echo "example cronjob" >> /cronjob_lob.txt 2>&1'
```

Now you have cronjob or cronjobs running inside of your container. 

> Remember that the container needs to have access to the directory where it shuold work. 
> If you have a website located inside another container you would have to create a volume that both containers have access to.

```
environment:
      CRONJOB: * * * * * php /var/www/public_html/cronfile.php >> /dev/null 2>&1
volumes:
      - "./public_html:/var/www/public_html"
```

## NOTICE
Your container needs to have all packages installed, on wich each cronjob depends on in order to work.

Example could be Laravel standard cron:

```
environment:
    CRONJOB: '* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1'
```

If you use that, you need to have all of the packages that laravel needs in order to execute the cron command.

[Laravel dependencies](https://laravel.com/docs/5.8/installation)

To do so, you simply create your own Dockerfile and install the packages
alpine3.10.0 Dockerfile example:

```
FROM thezochko/simple-cron:alpine3.10.0

RUN apk update && apk add --no-cache \
php7 \
php7-pdo_mysql \
php7-curl \
php7-json \
php7-session \
php7-bcmath \
php7-ctype \
php7-mbstring \
php7-openssl \
php7-tokenizer \
php7-xml

```

ubuntu18.04 Dockerfile example:

```
FROM thezochko/simple-cron:ubuntu18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
php7 \
php7-curl \
php7-mysqli \
php7-json

```

