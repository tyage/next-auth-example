FROM node:20

WORKDIR /app
ADD package.json /app
RUN npm install

ADD . .
COPY .env.local.example .env.local

RUN npm run build

ENTRYPOINT [ "./poc.sh" ]