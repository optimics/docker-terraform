FROM alpine:3.6

RUN apk add --update bash curl git python3 which
RUN apk add terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN curl -sSL https://sdk.cloud.google.com | bash

CMD ["/bin/bash"]
