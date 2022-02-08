FROM ruby:3.0.3-alpine3.15

WORKDIR /usr/src/app

COPY . .
RUN bundle config --global frozen 1 && \
    apk update && \
    apk add build-base && \
    bundle install

CMD ["bin/console"]
