FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libmysqlclient-dev nodejs && mkdir /pop
WORKDIR /pop

RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list && \
  echo deb http://archive.ubuntu.com/ubuntu precise-updates main universe >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y imagemagick && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /pop
RUN bundle install
