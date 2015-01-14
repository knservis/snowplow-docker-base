Snowplow base image
==================

This docker file is used to provide a base image for the excellent [snowplow](https://github.com/snowplow/snowplow) suite. The only two sub-projects that are compiled are the scala-stream-collector and the scala-kinesis-enrich. If you want to add compilation for any other sub-projects please submit a pull request.

Building the image
------------------

Make sure you have [docker](https://www.docker.com/) installed, then in the directory you have the Dockerfile do: 

    docker build -t knservis/snowplow-base:0.9.13 .

Publish the image
-----------------

In order to publish the [docker registry](https://hub.docker.com/) you simply have to do something like:

    docker push knservis/snowplow-base:0.9.13

Using the snowplow scala collector
----------------------------

To run snowplow scala kinesis collector you somehow have to provide a configuration file similar to the one found in: 

    /app/snowplow/snowplow/2-collectors/scala-stream-collector/src/main/resources/application.conf.example

One easy way to run it is to create a new Docker file which will contain:

    FROM knservis/snowplow-base:0.9.13
    WORKDIR /app/snowplow/2-collectors/scala-stream-collector/
    EXPOSE 80
    ADD ./collector.conf /app/snowplow/2-collectors/scala-stream-collector/
    CMD target/scala-2.10/snowplow-stream-collector-0.2.0 --config ./collector.conf

Using the snowplow scala kinesis enricher
-----------------------------------------

To run the snowplow scala kinesis enricher you need to provide a configuration file similar to the one found in: 

    /app/snowplow/snowplow/3-enrich/scala-kinesis-enrich/src/main/resources/default.conf

You will also need to configure you enrichments in: 
    
    /app/snowplow/snowplow/3-enrich/emr-etl-runner/config/enrichments/

One easy way to run it is to create a new Docker file which will contain:

    FROM knservis/snowplow-base:0.9.13
    WORKDIR /app/snowplow/3-enrich/scala-kinesis-enrich/
    ADD ./enrich.conf /app/snowplow/3-enrich/scala-kinesis-enrich/
    ADD ./enrichments.tar.bz2 /app/snowplow/3-enrich/scala-kinesis-enrich/enrichments
    CMD target/scala-2.10/snowplow-kinesis-enrich-0.2.1 --config enrich.conf  --enrichments enrichments/
