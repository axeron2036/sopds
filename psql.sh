#!/bin/sh

docker-compose exec db psql -U sopds -d sopds
