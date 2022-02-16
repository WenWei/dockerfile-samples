# -- Base
FROM node:carbon AS base
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# -- Dependencies
FROM base AS dependencies
COPY package*.json ./
RUN npm install --silent
RUN npm install react-scripts@3.4.3 -g --silent

# -- Copy Files/Build
FROM dependencies AS build
WORKDIR /app
COPY . /app
RUN npm run build

#FROM node:14.13.1-alpine3.12 AS release
#WORKDIR /app
#COPY --from=dependencies /app/package.json ./
#RUN npm install --only=production
#COPY --from=build /app ./

# production environment
FROM nginx:1.19.3-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]