# docker build -t auction:builder --target=builder .
FROM bitwalker/alpine-elixir-phoenix:1.8.0
# RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
#  && sed -i "s/nl.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
#  && apk upgrade \
#  && apk update \
#  && apk add python \
#     bash \
#     openssl \
#     curl \
#     build-base \
#     alpine-sdk \
#     python \
#     coreutils \
#     imagemagick \
#     tzdata

RUN mix local.rebar --force \
 && mix local.hex --force

WORKDIR /app
ENV MIX_ENV=dev


ADD . /app/
# COPY apps/auction_web/mix.* /app/apps/auction_web/
RUN HEX_HTTP_CONCURRENCY=5 HEX_HTTP_TIMEOUT=180 mix do deps.get, deps.compile

RUN cd assets && npm i

EXPOSE 4000

RUN ["chmod", "+x", "/app/migrate-and-run.sh"]

CMD ["/app/migrate-and-run.sh"]
