FROM ruby:3.0

# throw errors if Gemfile has been modified since Gemfile.lock

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.10
RUN bundle install --no-cache

COPY . .

CMD ruby main.rb
