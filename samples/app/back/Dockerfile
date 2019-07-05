FROM node:10.16

MAINTAINER howto-microservices

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Bundle app source
COPY . .

# Run app
EXPOSE 3000
CMD [ "npm", "start" ]
