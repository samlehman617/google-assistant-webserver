ARG BUILD_FROM=multiarch/debian-debootstrap:armhf-stretch
FROM $BUILD_FROM

COPY requirements.txt /


# Install packages
RUN apt-get update -qq > /dev/null \
    && apt-get install -yqq jq tzdata \
                            python3.6 python3.6-dev python3-pip \
                            python3-six python3-pyasn1 \
                            libportaudio2 alsa-utils
RUN pip3 install --upgrade pip \
RUN pip3 install --upgrade six \
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

ENTRYPOINT [ "/run.sh" ]
