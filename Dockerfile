FROM node:alpine

RUN apk add --no-cache ffmpeg openssl git bash python py-jinja2 make g++ \
 && apk add --no-cache --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ vips-dev fftw-dev

RUN git clone --branch develop https://github.com/Chocobozzz/PeerTube app

WORKDIR /app

RUN bash -c 'yarn install --pure-lockfile && npm run build'

ENV NODE_ENV production

COPY conf /conf
COPY start.py /start.py

CMD /start.py
