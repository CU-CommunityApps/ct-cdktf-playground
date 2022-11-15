#!/bin/bash

# Create the image
docker-compose --file docker-compose.yml build cdktf

# Run the image
docker-compose --file docker-compose.yml up --detach --remove-orphans

# Drop into a shell
docker-compose --file docker-compose.yml exec cdktf bash
