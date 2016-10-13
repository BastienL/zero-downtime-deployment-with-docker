#!/bin/bash

# Edit these constants
APP_NAME="app"
APP_CONTAINERS_NAME="docker_app"
NUM_OF_APP_CONTAINERS=2
DEPLOYMENT_TIME=10
# End of edit

docker-compose pull $APP_NAME # Use (docker-compose build $APP_NAME if you use a custom image) 
docker-compose scale $APP_NAME=$(($NUM_OF_APP_CONTAINERS*2))

sleep $DEPLOYMENT_TIME

FIRST_APP_CONTAINER_NUM=`docker inspect --format='{{.Name}}' $(docker ps -q) | grep $APP_CONTAINERS_NAME | awk -F  "_" '{print $NF}' | sort | head -1`

for ((i=$FIRST_APP_CONTAINER_NUM;i<$FIRST_APP_CONTAINER_NUM+$NUM_OF_APP_CONTAINERS;i++))
do
   docker stop "$APP_CONTAINERS_NAME"_"$i"
   docker rm "$APP_CONTAINERS_NAME"_"$i"
done
