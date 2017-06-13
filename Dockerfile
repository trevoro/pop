FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /pop2
WORKDIR /pop2
ADD Gemfile /pop2/Gemfile
ADD Gemfile.lock /pop2/Gemfile.lock
RUN bundle install
ADD . /pop2
