#!/usr/bin/env bash

# variables
CONTAINER_REGISTRY_USERNAME=xxxx@alicloudintl
CONTAINER_REGISTRY_PASSWORD=xxxxxxxx
CONTAINER_REGISTRY_NAMESPACE=xxxxx
CONTAINER_REGISTRY_REGISTRY_URL=registry.ap-northeast-1.aliyuncs.com
CONTAINER_REGISTRY_IMAGE_NAME=howto-microservices-database-app
CONTAINER_REGISTRY_IMAGE_VERSION=1.0.0
CONTAINER_REGISTRY_REPOSITORY_URL=$CONTAINER_REGISTRY_REGISTRY_URL/$CONTAINER_REGISTRY_NAMESPACE/$CONTAINER_REGISTRY_IMAGE_NAME

# build a container image
docker build -t $CONTAINER_REGISTRY_IMAGE_NAME:$CONTAINER_REGISTRY_IMAGE_VERSION .

# push a container image
echo $CONTAINER_REGISTRY_PASSWORD | docker login -u=$CONTAINER_REGISTRY_USERNAME --password-stdin $CONTAINER_REGISTRY_REGISTRY_URL
docker tag $CONTAINER_REGISTRY_IMAGE_NAME:$CONTAINER_REGISTRY_IMAGE_VERSION $CONTAINER_REGISTRY_REPOSITORY_URL:$CONTAINER_REGISTRY_IMAGE_VERSION
docker push $CONTAINER_REGISTRY_REPOSITORY_URL:$CONTAINER_REGISTRY_IMAGE_VERSION
