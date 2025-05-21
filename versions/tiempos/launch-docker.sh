#!/bin/bash
docker stop $(docker ps -qa -f name=edhoc-c-edhoc-c-test-1)
docker compose -f ../../docker-compose.yml up --build -d

