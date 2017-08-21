FROM phusion/baseimage:0.9.20
MAINTAINER Pro Football Focus <devops@profootballfocus.com>
LABEL org.label-schema.vcs-url="https://github.com/pro-football-focus/docker-php"
ENV REFRESHED_AT 2017-08-21

# Setup the environment
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo /root > /etc/container_environment/HOME

# Use the baseimage init system
CMD ["/sbin/my_init"]

# Make the required ports available
EXPOSE 80

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Work in the /tmp directory
WORKDIR /tmp

# Install required packages (includes Apache 2.4 + PHP 5.6)
RUN add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install --no-install-recommends -y apache2 php5.6 php5.6-mysql php5.6-mbstring libapache2-mod-php5.6 php5.6-memcache php5.6-xml php5.6-mcrypt php5.6-gd php5.6-bz2 php5.6-zip php5.6-curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure Apache
RUN a2enmod headers
RUN a2enmod rewrite
ADD docker-apache.conf /etc/apache2/sites-available/000-default.conf

# Configure PHP
RUN ln -sfn /usr/bin/php5.6 /etc/alternatives/php

# Add our app server daemon
RUN mkdir /etc/service/app
ADD docker-app.sh /etc/service/app/run
RUN chmod +x /etc/service/app/run

# Move to the HTML directory for future commands
WORKDIR /var/www/html
