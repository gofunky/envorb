ARG BASE
FROM ${BASE}
LABEL maintainer="mat@fax.fyi"

WORKDIR /test

COPY . /test
RUN chmod +x ./sut.sh

ENTRYPOINT ["./sut.sh"]
