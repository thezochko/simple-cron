# Simple Cron 

[alpine3.10.0](https://github.com/thezochko/simple-cron/tree/master) - 5 MB
[ubuntu18.04](https://github.com/thezochko/simple-cron/tree/master) - 49 MB

This image is designed to make settinup a cron container alot easier.
You will have crontab available out of the box.
And you will be able to implement cronjob/cronjobs in two different ways when using this image.

## So what you need to do

One of two things:

### 1 .
Create a volume with the name of "docker-entrypoint-initcron.d" on your container site

```
volumes:
      - "./docker-entrypoint-initcron.d:/docker-entrypoint-initcron.d"
```

What you call it on the host site we dont care about.
But we need to have a file "cronjobs.txt" or files "conjob.txt cronjob.txt etc" where all of your cronjobs are listed.

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
    CRONJOB: '* * * * echo "example cronjob" >> /cronjob_lob.txt 2>&1'
```

Now you have cronjob or cronjobs running inside of your container. 

> Remember that the container needs to have access to the directory where it shuold work. 
> If you have a website located inside another container you would have to create a volume that both containers have access > to.

```
environment:
      CRONJOB: * * * * php /var/www/cronfile.php >> /dev/null 2>&1
volumes:
      - "./public_html:/var/www/public_html"
```

## NOTICE
Your container needs to have packages installed wich each cronjob needs in order to work.
Example would be Laravel standart cron:

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

