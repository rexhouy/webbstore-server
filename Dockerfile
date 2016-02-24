FROM ruby:2.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle config mirror.https://rubygems.org https://ruby.taobao.org/
ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
Status API Training Shop Blog About Pricing
