FROM node:20 as builder

WORKDIR /usr/src/app
ENV PATH /usr/src/node_modules/.bin:$PATH

COPY package.json ./
COPY package-lock.json ./

RUN npm install

COPY . ./

FROM builder as prod-builder
RUN npm run build

FROM nginx:1.27.2 as prod

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=prod-builder /usr/src/app/dist /usr/share/nginx/html

COPY env.sh /docker-entrypoint.d/env.sh
RUN chmod +x /docker-entrypoint.d/env.sh

CMD ["nginx", "-g", "daemon off;"]
