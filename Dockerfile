# build environment
FROM node:16.10 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# production environment
FROM nginx:1.13.9-alpine
RUN rm -rf /etc/nginx/conf.d
RUN mkdir -p /etc/nginx/conf.d
COPY ./default.conf /etc/nginx/conf.d/
# COPY /app/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/dist/le-mans24 /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
