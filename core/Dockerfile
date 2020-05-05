FROM ruby:2.7.0

# Needed stages
# ARG definitions
ENV VIPS_VERSION 8.8.3

# ENV definitions
ENV INSTALL_PATH /app
ENV DB_URL sql
ENV REDIS_URL redis:6379
ENV SECRET_TOKEN 09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e # CHANGE THIS
ENV SECRET_KEY 09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e # CHANGE THIS
ENV RAILS_ENV=production

RUN mkdir -p $INSTALL_PATH

RUN gem install rails bundler
WORKDIR $INSTALL_PATH

# 3: Install dependencies
RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN wget -qO - https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn build-essential git
RUN gem install bundler

# 3a: Install shoreman
ADD https://github.com/chrismytton/shoreman/raw/master/shoreman.sh /usr/bin/shoreman
RUN chmod +x /usr/bin/shoreman

# 3b: Install libvips
RUN cd /tmp; \
    wget -q https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz; \
    tar -xf vips-$VIPS_VERSION.tar.gz; \
    cd vips-$VIPS_VERSION; \
    ./configure --prefix=/usr; \
    make install; \
    ldconfig; \
    cd $INSTALL_PATH; \
    rm -fr /tmp/vips-$VIPS_VERSION.tar.gz /tmp/vips-$VIPS_VERSION;

# 4: Clone e621 to app folder
# 4a: Cache invalidator
ADD https://api.github.com/repos/zwagoth/e621ng/git/refs/heads/master /version.json
RUN git clone https://github.com/zwagoth/e621ng.git /app

# 5: Install bundler stuff
RUN bundle install
RUN bundle check

# 6: Install yarn stuff
RUN yarn install

# Apply db migration fixes
COPY migration_patch.diff /app/migration_patch.diff
RUN git apply migration_patch.diff
COPY disable_ssl.diff /app/disable_ssl.diff
RUN git apply disable_ssl.diff

# Disable uploader limitations
COPY uploader_accept_0_tags.diff /app/uploader_accept_0_tags.diff
RUN git apply uploader_accept_0_tags.diff

# 7: sed config to db
RUN sed -s "s/url: <%= .* %>/host: $DB_URL/g" script/install/database.yml.templ > config/database.yml
# 7a: sed redis
RUN sed -i "s/url: <%= .* %>/url: $REDIS_URL/g" config/cable.yml

# 8: CP config template
RUN cp script/install/danbooru_local_config.rb.templ config/danbooru_local_config.rb

# 9: Set up token + key
RUN mkdir -p ~/.danbooru
RUN echo $SECRET_TOKEN > ~/.danbooru/secret_token
RUN echo $SECRET_KEY > ~/.danbooru/session_secret_key
RUN chmod -R 600 ~/.danbooru

# 10: Webpack compile
RUN rails assets:precompile

# 11: Set up wait
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

# 12: Run startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD /wait && /run.sh
