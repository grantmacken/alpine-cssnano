# syntax=docker/dockerfile:experimental

# 12.14.1 LTS

FROM  mhart/alpine-node:12.14.1 as bld
WORKDIR = /home

COPY package.json ./
RUN yarn install
    # # && npm list -g \
    # && npm install cssnano --save-dev \
    # # && npm list \
    # && npm uninstall npx -g \
    # && npm uninstall yarn -g \
    # && npm uninstall npm -g

RUN mv node_modules /usr/local/

FROM  mhart/alpine-node:slim-12.14.1 as postcss

WORKDIR /home

COPY --from=bld /usr/local/node_modules  ./node_modules 
# COPY --from=bld /usr/local/lib/node_modules /usr/local/lib/node_modules 
COPY postcss.config.js ./
ENV LANG C.UTF-8
# RUN ls -al  ./node_modules \
#     && false
#     && ln -s /usr/local/node_modules/.bin/*  /usr/local/bin \
#     && ls /usr/local/bin

ENV LANG C.UTF-8
ENTRYPOINT ["/home/node_modules/.bin/postcss"]

