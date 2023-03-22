FROM alpine:3.17

RUN apk add --update bash curl git python3 which npm \
  'jq=1.6-r2' \
  'nodejs=18.14.2-r0' \
  'poetry=1.2.2-r0' \
  'terraform=1.3.4-r2'
RUN curl -sSL https://sdk.cloud.google.com | bash

COPY ./descope-env.sh /usr/local/bin/descope-env
COPY ./init-gcs.sh /usr/local/bin/init-gcs

RUN \
  chmod +x /usr/local/bin/descope-env && \
  chmod +x /usr/local/bin/init-gcs

ENV PATH=$PATH:/root/google-cloud-sdk/bin
CMD ["/bin/bash"]
