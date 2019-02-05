ARG BUILD_FROM
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION
FROM $BUILD_FROM

# Install packages
RUN apt-get update
RUN apt-get install -y jq tzdata python3 python3-dev python3-pip \
  python3-six python3-pyasn1 libportaudio2 alsa-utils
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade six
RUN pip3 install --upgrade google-assistant-library google-auth \
  requests_oauthlib cherrypy flask flask-jsonpify flask-restful \
  grpcio google-assistant-grpc google-auth-oauthlib
RUN apt-get remove -y --purge python3-pip python3-dev
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# Copy data
COPY run.sh /
COPY *.py /

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]

LABEL \
  maintainer="Sam Lehman <samlehman617@gmail.com" \
  org.label-schema.description="Google Assistant Webserver to make RESTful requests to." \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name="Google Assistant Webserver" \
  org.label-schema.url="https://github.com/samlehman617/google-assistant-webserver" \
  org.label-schema.vcs-ref=${BUILD_REF} \
  org.label-schema.vcs-url="https://github.com/samlehman617/google-assistant-webserver" \
  org.label-schema.vendor="Sam Lehman" \
  org.label-schema.version=${BUILD_VERSION}
