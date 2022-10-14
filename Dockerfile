FROM alpine:3.16

RUN \
  apk add --update bash curl git python3 which 'nodejs=16.17.1-r0' npm && \
  apk add 'terraform=1.3.2-r0' --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN curl -sSL https://sdk.cloud.google.com | bash

COPY ./descope-env.sh /usr/local/bin/descope-env
COPY ./init-gcs.sh /usr/local/bin/init-gcs

RUN \
  chmod +x /usr/local/bin/descope-env && \
  chmod +x /usr/local/bin/init-gcs

ENV PATH=$PATH:/root/google-cloud-sdk/bin
CMD ["/bin/bash"]
