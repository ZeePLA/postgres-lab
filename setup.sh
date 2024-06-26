#!/bin/bash

# Clone the repository
git clone https://github.com/ZeePLA/postgres-lab.git
cd postgres-lab

# Build the Docker image
docker build -t psql-labv1 .

# Run the Docker container
docker run -d -p 5432:5432 --name psql-lab1 psql-labv1
