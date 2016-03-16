FROM ubuntu:14.04
MAINTAINER Nils Eriksson
ENV REFRESHED_AT 2016-03-16

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl git

# For some reason, installing Elixir tries to remove this file
# and if it doesn't exist, Elixir won't install. So, we create it.
RUN touch /etc/init.d/couchdb

#install erlang
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
 && dpkg -i erlang-solutions_1.0_all.deb \
 && apt-get update
RUN apt-get install -y esl-erlang

#install Elixir
# install latest elixir package
RUN apt-get update && apt-get install -y elixir

#install Phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

#Install Nodejs
RUN DEBIAN_FRONTEND=noninteractive wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash - && apt-get install -y nodejs



RUN mkdir -p /app
COPY . ./app
WORKDIR /app

#install hex
RUN yes | mix local.hex

#install dependencies
RUN npm install
RUN yes | mix deps.get

#build production
RUN yes | MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix phoenix.digest

#start app
CMD ["mix", "phoenix.server"]
