ARG BASE
FROM ${BASE}
MAINTAINER matfax <mat@fax.fyi>

WORKDIR /test

COPY . /test
RUN chmod +x ./sut.sh

ENTRYPOINT ["./sut.sh"]
