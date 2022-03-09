FROM alpine:3.13

RUN apk add --update bash curl git python3 which
RUN apk add terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN curl -sSL https://sdk.cloud.google.com | bash

ENV PATH=$PATH:/root/google-cloud-sdk/bin
CMD ["/bin/bash"]
