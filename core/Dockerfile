FROM ruby:2.7.0

# Needed stages
# ARG definitions
ENV VIPS_VERSION 8.8.3

# ENV definitions
ENV INSTALL_PATH /app
ENV DB_URL sql
ENV REDIS_URL redis:6379
ENV RAILS_ENV=production

ENV SECRET_TOKEN 09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e
ENV SECRET_KEY 09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e
ENV PGHOST sql
ENV PGUSER root
ENV PGPASSWORD changethis

RUN mkdir -p $INSTALL_PATH

# 3: Install dependencies
RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list; \
    wget -qO - https://deb.nodesource.com/setup_10.x | bash -; \
    apt-get update && apt-get install --no-install-recommends -y nodejs yarn build-essential git ffmpeg postgresql-client && rm -rf /var/lib/apt/lists/*; \
    apt-get update && apt-get install --no-install-recommends -y libicu-dev libjpeg-progs libpq-dev libreadline-dev libxml2-dev libexpat1-dev liblcms2-dev libjpeg62-turbo-dev libgif-dev libpng-dev libexif-dev && rm -rf /var/lib/apt/lists/*; \
    gem install rails bundler;

WORKDIR $INSTALL_PATH

# 3a: Install shoreman
COPY shoreman.sh /usr/bin/shoreman

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

# 3c: Install broken gems (bundler doesn't like these)
RUN gem install nokogumbo -v '2.0.2'

# 4: Copy functional e621 to app folder
# 4a: copy Gemfile + lock
COPY e621_code/Gemfile /app/Gemfile
COPY e621_code/Gemfile.lock /app/Gemfile.lock
# 4b: Install gemfile
RUN bundle install

# Copy rest of the code
COPY e621_code /app

# 5: Install bundler and yarn stuff
RUN bundle check && yarn install

# 6: Apply source patches
COPY patches/*.diff /app/patches/
RUN git apply /app/patches/*.diff

# 7: sed db and redis url
RUN sed -s "s/url: <%= .* %>/host: $DB_URL/g" script/install/database.yml.templ > config/database.yml; \
    sed -i "s/url: <%= .* %>/url: $REDIS_URL/g" config/cable.yml

# 8: CP config template
RUN cp script/install/danbooru_local_config.rb.templ config/danbooru_local_config.rb

# 9: Set up token + key
RUN mkdir -p ~/.danbooru; \
    echo $SECRET_TOKEN > ~/.danbooru/secret_token; \
    echo $SECRET_KEY > ~/.danbooru/session_secret_key; \
    chmod -R 600 ~/.danbooru;

# 10: Webpack compile
RUN rails assets:precompile

# 11: Set up wait
COPY wait /wait

# 12: Run startup script
COPY run.sh /run.sh
CMD /wait && /run.sh
