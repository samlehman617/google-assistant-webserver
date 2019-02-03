ARG BUILD_FROM=multiarch/debian-debootstrap:armhf-stretch
FROM $BUILD_FROM

COPY requirements.txt /

# Install packages
RUN apt-get update -qq > /dev/null \
    && apt-get install -yqq jq tzdata \
                            python3 python3-dev python3-pip \
                            python3-six python3-pyasn1 \
                            libportaudio2 alsa-utils
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade six
RUN pip3 install --upgrade -r /requirements.txt

# RUN pip3 install --upgrade google-assistant-library google-auth requests_oauthlib \
#                            cherrypy flask flask-jsonpify flask-restful \
#                            grpcio google-assistant-grpc google-auth-oauthlib
RUN apt-get remove -y --purge python3-pip python3-dev \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Copy data
COPY run.sh /
COPY *.py /

RUN chmod a+x /run.sh

# Run this after setup
ENTRYPOINT [ "/run.sh" ]


# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
  io.hass.name="Google Assistant Webserver" \
  io.hass.description="Google Assistant webserver Hass.io add-on" \
  io.hass.arch="${BUILD_ARCH}" \
  io.hass.type="addon" \
  io.hass.version=${BUILD_VERSION} \
  maintainer="Sam Lehman <samlehman617@gmail.com" \
  org.label-schema.description="Google Assistant webserver Hass.io add-on" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name="Google Assistant Webserver" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.url="https://github.com/samlehman617/google-assistant-webserver" \
  org.label-schema.usage="https://github.com/samlehman617/google-assistant-webserver" \
  org.label-schema.vcs-ref=${BUILD_REF} \
  org.label-schema.vcs-url="https://github.com/samlehman617/google-assistant-webserver" \
  org.label-schema.vendor="Sam Lehman" \
  org.label-schema.version=${BUILD_VERSION}
