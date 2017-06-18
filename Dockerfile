FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /pop
WORKDIR /pop
ADD Gemfile /pop/Gemfile
ADD Gemfile.lock /pop/Gemfile.lock
RUN bundle install
ADD . /pop
