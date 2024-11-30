FROM ruby:3.3.6-slim

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE="ja_JP:ja"
ENV BUNDLER_VERSION 2.5.23

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim git imagemagick
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
ADD .ruby-version /app/.ruby-version

RUN bundle config set path 'vendor/bundle'
RUN gem update --system \
    && gem install bundler -v $BUNDLER_VERSION \
    && bundle install -j 4

RUN bundle install
ADD . /app
