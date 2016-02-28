FROM phusion/passenger-ruby22:0.9.18

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf
ADD env.conf /etc/nginx/main.d/env.conf

# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN gem sources --remove https://rubygems.org/
RUN gem sources -a https://ruby.taobao.org/
RUN gem sources -l
RUN bundle config mirror.https://rubygems.org https://ruby.taobao.org/
RUN bundle install

# Add the Rails app
ADD . /home/app/webapp
RUN chown -R app:app /home/app/webapp

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN apt-get update && apt-get install -y nodejs --no-install-recommends
# RUN apt-get install -y mysql-client --no-install-recommends
# RUN apt-get install -y nginx --no-install-recommends
