# rabbitmq-mqtt

see [Docker image on docker hub](https://registry.hub.docker.com/u/sntk/rabbitmq-mqtt/).

docker build -t="dockerfile/rabbitmq" .

docker run -d -p 15672:15672 -p 1883:1883 sntk/rabbitmq-mqtt
