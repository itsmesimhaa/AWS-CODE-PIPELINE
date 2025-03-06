#!/bin/bash
set -e

# Stop the running container
containerid=$(docker ps -q)

if [ ! -z "$containerid" ]; then
    docker rm -f $containerid
    echo "Stopped and removed container: $containerid"
else
    echo "No running containers found."
fi
