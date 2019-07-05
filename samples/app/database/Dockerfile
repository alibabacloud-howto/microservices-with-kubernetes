FROM openjdk:12

MAINTAINER howto-microservices

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
COPY target/database-app-1.0-SNAPSHOT.jar .

# Run app
EXPOSE 8080
CMD ["java", "-jar", "database-app-1.0-SNAPSHOT.jar"]
