FROM ruby:3.2.2-slim
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim git imagemagick
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

ENV BUNDLER_VERSION 2.4.19
RUN gem update --system \
    && gem install bundler -v $BUNDLER_VERSION \
    && bundle install -j 4

RUN bundle install
ADD . /app
