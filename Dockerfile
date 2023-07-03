FROM alpine:3.18

RUN apk add --update bash curl git python3 which npm \
  'jq=1.6-r3' \
  'nodejs=18.16.1-r0' \
  'poetry=1.4.2-r1' \
  'terraform=1.4.6-r1'
RUN curl -sSL https://sdk.cloud.google.com | bash

COPY ./descope-env.sh /usr/local/bin/descope-env
COPY ./init-gcs.sh /usr/local/bin/init-gcs

RUN \
  chmod +x /usr/local/bin/descope-env && \
  chmod +x /usr/local/bin/init-gcs

ENV PATH=$PATH:/root/google-cloud-sdk/bin
CMD ["/bin/bash"]
