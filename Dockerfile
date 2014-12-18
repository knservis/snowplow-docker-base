FROM ubuntu:14.04
MAINTAINER Konstantinos Servis <knservis@gmail.com>

RUN apt-get -qq update
RUN apt-get -qqy install software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -qq update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -qqy install oracle-java7-installer
RUN update-alternatives --display java
RUN apt-get -qqy install curl
RUN curl -LO http://apt.typesafe.com/repo-deb-build-0002.deb && dpkg -i repo-deb-build-0002.deb && apt-get -qq update && apt-get -yqq install scala
RUN curl -LO https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb && dpkg -i sbt-0.13.7.deb

ENV SNOWPLOW_VERSION 0.9.13

RUN apt-get -qqy install git
RUN git clone https://github.com/snowplow/snowplow /app/snowplow && cd /app/snowplow && git checkout $SNOWPLOW_VERSION
RUN cd /app/snowplow/3-enrich/scala-kinesis-enrich/ && sbt assembly 
RUN cd /app/snowplow/2-collectors/scala-stream-collector/ && sbt assembly 
