FROM ubuntu:xenial

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    avahi-daemon \
    build-essential \
    ca-certificates \
    dbus \
    git \
    libasound2-dev \
    libavahi-client-dev \
    libdaemon-dev \
    libpopt-dev \
    libssl-dev \
    libconfig-dev \
    libtool \
    supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt

RUN mkdir -p /var/log/supervisor /var/run/dbus && \
    git clone --depth 1 https://github.com/mikebrady/shairport-sync.git && \
    cd shairport-sync && \
    autoreconf -i -f && \
    ./configure --with-alsa --with-avahi --with-ssl=openssl && \
    make && \
    make install && \
    cd / && \
    rm -rf /shairport-sync

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV SPEAKER_NAME=Shairport
EXPOSE 5353 5000

CMD ["supervisord"]
