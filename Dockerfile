FROM node:14

WORKDIR /usr/src/app

COPY src/package*.json ./

RUN npm install

COPY src/*.js ./

EXPOSE 8080
ENTRYPOINT node event-coordinator-publisher.js
