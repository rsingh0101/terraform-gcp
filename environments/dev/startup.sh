#!/bin/bash
apt-get update
apt-get install -y docker.io docker-compose
usermod -aG docker $USER

cd /home/ubuntu
git clone https://github.com/your-repo/redis-benchmarking.git
cd redis-benchmarking/docker
docker-compose up -d

