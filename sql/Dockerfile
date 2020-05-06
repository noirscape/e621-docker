FROM postgres:11-alpine

RUN apk --no-cache add make gcc libc-dev clang llvm
COPY test_parser /tmp/test_parser
RUN cd /tmp/test_parser; make install; rm -rf /tmp/test_parser
ADD https://raw.githubusercontent.com/zwagoth/e621ng/master/db/structure.sql /docker-entrypoint-initdb.d/structure.sql
RUN chmod 777 /docker-entrypoint-initdb.d/structure.sql
