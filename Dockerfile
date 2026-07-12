FROM node:24-alpine

RUN apk add --no-cache bash

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 3000

# Zawsze uruchomi się jako pierwszy
ENTRYPOINT ["./entrypoint.sh"]

CMD ["node", "app.js"]