FROM node:lts-slim as builder

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn

COPY tsconfig*.json nest-cli.json ./

COPY src src/

RUN yarn build && rm -rf node_modules tsconfig*.json nest-cli.json src

RUN yarn --prod && ls -ahl && rm -rf yarn.lock .husky

#####
FROM node:lts-slim

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/ ./

ENV NODE_OPTIONS="--experimental-specifier-resolution=node"

ENTRYPOINT [ "node", "--enable-source-maps", "dist/main.js" ]
