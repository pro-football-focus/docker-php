# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# @trenpixster wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return
# ----------------------------------------------------------------------------

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
#
# Usage Example : Run One-Off commands
# where <VERSION> is one of the baseimage-docker version numbers.
# See : https://github.com/phusion/baseimage-docker#oneshot for more examples.
#
#  docker run --rm -t -i phusion/baseimage:<VERSION> /sbin/my_init -- bash -l
#
# Thanks to @hqmq_ for the heads up
FROM phusion/baseimage:0.9.19
MAINTAINER Pro Football Focus <devops@profootballfocus.com>
LABEL org.label-schema.vcs-url="https://github.com/pro-football-focus/docker-php"

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT 2016-11-08

# Set time timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

# Set correct environment variables.

# Setting ENV HOME does not seem to work currently. HOME is unset in Docker container.
# See bug : https://github.com/phusion/baseimage-docker/issues/119
#ENV HOME /root
# Workaround:
RUN echo /root > /etc/container_environment/HOME

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Make the required ports available
EXPOSE 80

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Update the package lists
RUN apt-get update

# Work in the /tmp directory
WORKDIR /tmp

# Install & configure apache
RUN apt-get install -y apache2
RUN a2enmod headers
RUN a2enmod rewrite
ADD docker-apache.conf /etc/apache2/sites-available/000-default.conf

# Install & configure PHP
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update
RUN apt-get -y install php5.6 php5.6-mysql php5.6-mbstring libapache2-mod-php5.6 php5.6-memcache php5.6-xml php5.6-mcrypt php5.6-gd php5.6-bz2 php5.6-zip php5.6-curl
RUN a2dismod php7.0; a2enmod php5.6; service apache2 restart
RUN ln -sfn /usr/bin/php5.6 /etc/alternatives/php
RUN apt-get purge
RUN apt-get autoremove

# Clean up from the install process
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add our app server daemon
RUN mkdir /etc/service/app
ADD docker-app.sh /etc/service/app/run
RUN chmod +x /etc/service/app/run

# Move to the HTML directory for future commands
WORKDIR /var/www/html