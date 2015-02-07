FROM ubuntu:14.04

# Install system dependencies
RUN apt-get -y update
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev wget libsqlite3-dev git

# Download ruby 2.1.5
WORKDIR /tmp/
RUN wget -q -O /tmp/ruby-2.1.5.tar.gz http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
RUN tar xvf ruby-2.1.5.tar.gz

# Install ruby 2.1.5
WORKDIR /tmp/ruby-2.1.5/
RUN ./configure
RUN make -j 4
RUN make -j 4 install
RUN gem install bundler

# Add app code and set file permissions
WORKDIR /
ADD . /opt/cappy/backend
RUN useradd --create-home --user-group backend
RUN chown -R backend:backend /opt/cappy/

# Install ruby dependencies
WORKDIR /opt/cappy/backend
USER backend
RUN bundle config --global jobs 8
RUN bundle install --deployment

# Default startup command
CMD bundle exec rake web
ENV REDIS_HOST redis
