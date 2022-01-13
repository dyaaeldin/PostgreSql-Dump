FROM alpine:3.12
WORKDIR /work
COPY entrypoint.sh ./
COPY ./scripts/ /usr/local/bin/
RUN apk update && \
    apk add python3 py3-pip openssh-client ca-certificates postgresql-client tzdata && \
    pip3 install --no-cache-dir awscli && \
    rm -rf /var/cache/apk/* && \
    chmod a+x /usr/local/bin/* && \
    chmod a+x ./entrypoint.sh
    
CMD ["/work/entrypoint.sh"]
