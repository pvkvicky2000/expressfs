FROM node:latest

# Create application directory

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install -g npm@10.8.2 && npm install

COPY . .

EXPOSE 8080
CMD [ "node", "app.js" ]


