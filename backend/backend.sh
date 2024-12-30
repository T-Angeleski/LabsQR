#!/bin/bash

# Check if the --profile flag is provided
PROFILE=${1:-postgres}

echo "Building the backend with profile: $PROFILE"
./mvnw clean package -DskipTests -Dspring.profiles.active=$PROFILE

# Start the backend locally (if H2) or with Docker Compose (if Postgres)
if [ "$PROFILE" == "h2" ]; then
    echo "Running backend locally with H2..."
    java -Dspring.profiles.active=h2 -jar target/*.jar
else
    echo "Starting Docker Compose with Postgres..."
    docker-compose up --build
fi
