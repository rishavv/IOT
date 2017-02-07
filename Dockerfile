#
# MQTT/RabbitMQ
#
# based on:
# RabbitMQ Dockerfile
#
# https://github.com/dockerfile/rabbitmq
#

# Pull base image.
FROM ubuntu:16.04


#Golang installation...


RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update
RUN apt-get -y install curl

ENV GOLANG_VERSION 1.6.4
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 b58bf5cede40b21812dfa031258db18fc39746cc0972bc26dae0393acc377aaf

RUN curl  -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

#COPY go-wrapper /usr/local/bin/


#################Done ###################

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Install RabbitMQ.
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget

RUN wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server apg
RUN rm -rf /var/lib/apt/lists/*

# Add files.
ADD bin/rabbitmq-start /usr/local/bin/
RUN chmod +x /usr/local/bin/rabbitmq-start

ADD etc/rabbitmq/rabbitmq.config /etc/rabbitmq/
ADD etc/rabbitmq/rabbitmq-env.conf /etc/rabbitmq/

# initial config
RUN rabbitmq-plugins enable rabbitmq_management rabbitmq_mqtt 

# Define default command.
CMD ["rabbitmq-start"]

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 1883

