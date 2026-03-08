FROM alpine AS base

FROM base AS builder
WORKDIR /source-code
COPY . .

RUN apk add --update \
    g++ \
    make \
    py3-pip \
    nodejs \
    npm \
  && npm ci && npm run build \
  && rm -rf node_modules && npm ci --omit=dev \
  && mkdir build-output \
  && mv server node_modules config.js index.js package.json public -t build-output


FROM base AS final
WORKDIR /server

RUN apk add --update --no-cache nodejs

COPY --from=builder ./source-code/build-output ./

VOLUME /lxmusic/data
ENV DATA_PATH '/lxmusic/data'
ENV LOG_PATH '/lxmusic/data/logs'

EXPOSE 9527
ENV NODE_ENV 'production'
ENV PORT 9527
ENV BIND_IP '0.0.0.0'
# ENV PROXY_HEADER 'x-real-ip'
# ENV SERVER_NAME 'My Sync Server'
# ENV MAX_SNAPSHOT_NUM '10'
# ENV LIST_ADD_MUSIC_LOCATION_TYPE 'top'
ENV zjw 'Destiny959.'
# ENV LX_USER_user2 '{ "password": "123.456", "maxSnapshotNum": 10, "list.addMusicLocationType": "top" }'
ENV CONFIG_PATH '/lxmusic/config.js'
# ENV WEBDAV_URL ''
# ENV WEBDAV_USERNAME ''
# ENV WEBDAV_PASSWORD ''
# ENV SYNC_INTERVAL '60'
# ENV ENABLE_WEBPLAYER_AUTH 'false'
ENV WEBPLAYER_PASSWORD 'EkUk7oq4hMQEU!gK'
ENV LOG_PATH '/lxmusic/logs'
ENV DATA_PATH '/lxmusic/data'
# ENV PLAYER_ENABLE_AUTH 'true'
# ENV PLAYER_PASSWORD '123.456'

CMD [ "node", "index.js" ]
