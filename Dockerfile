ARG BASE
FROM ${BASE}
LABEL maintainer="mat@fax.fyi"

COPY ./load.sh /usr/local/bin/envload
RUN chmod +x /usr/local/bin/envload
