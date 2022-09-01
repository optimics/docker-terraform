FROM alpine:3.16

COPY ./descope-env.sh /usr/local/bin/descope-env

RUN chmod +x /usr/local/bin/descope-env && \
  apk add --update bash curl git python3 which nodejs npm && \
  apk add terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN curl -sSL https://sdk.cloud.google.com | bash

ENV PATH=$PATH:/root/google-cloud-sdk/bin
CMD ["/bin/bash"]
