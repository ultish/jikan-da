#!/bin/bash

docker-compose down;
pnpm build;
docker build -t jikan-da .;
docker-compose up -d;
