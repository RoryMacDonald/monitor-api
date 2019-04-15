FROM ruby:2.6.2-alpine3.9

RUN apk --no-cache add postgresql-dev postgresql-libs postgresql-client less
RUN apk --no-cache add valgrind

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN apk --no-cache add alpine-sdk && bundle install && apk del alpine-sdk

ADD . /app

EXPOSE 4567
