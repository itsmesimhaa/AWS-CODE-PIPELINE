#!/bin/bash
set -e

#docker pull image
docker pull itsmesimha/simple-python-flask-app:latest

#docker run
docker run -d -p 5000:5000 itsmesimha/simple-python-flask-app:latest
