FROM node:20-alpine AS builder

RUN apk add --no-cache curl

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install 

COPY . .

RUN npm run build

FROM nginx:1.27-alpine AS runtime

RUN apk add --no-cache tree \
    && addgroup -g 1001 -S xyz \
    && adduser -u 1001 -S abc -G xyz -s /sbin/nologin \
    && mkdir -p /var/cache/nginx \
    /var/run/nginx \
    /var/log/nginx \
    && chown -R abc:xyz \
    /var/cache/nginx \
    /var/run/nginx \
    /var/log/nginx \
    /etc/nginx/conf.d \
    /usr/share/nginx/html \
    && touch /var/run/nginx/nginx.pid \
    && chown abc:xyz /var/run/nginx/nginx.pid \
    && chmod -R 755 /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=builder --chown=abc:xyz /app/build /usr/share/nginx/html

USER abc

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]