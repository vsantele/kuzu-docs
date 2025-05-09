FROM node:20-bookworm AS build
COPY package.json package-lock.json /home/node/app/
WORKDIR /home/node/app
RUN npm i
COPY . .
RUN npx astro build

FROM httpd:2.4-alpine AS deploy
WORKDIR /home/node/app
COPY --from=build /home/node/app/dist /usr/local/apache2/htdocs/
# Disallow all robots for dev documentation
RUN printf "User-agent: *\nDisallow: /\n" > /usr/local/apache2/htdocs/robots.txt
EXPOSE 80
