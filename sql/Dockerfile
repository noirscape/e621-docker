FROM postgres:11-alpine

RUN apk --no-cache add make gcc libc-dev clang llvm
COPY test_parser /tmp/test_parser
RUN cd /tmp/test_parser; make install; rm -rf /tmp/test_parser
