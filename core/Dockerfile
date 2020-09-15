# Stage to build libvips
FROM debian:buster-slim AS vips-builder

# ARG definitions
ENV VIPS_VERSION 8.8.3

# 2: Install libvips dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    build-essential \
    pkg-config \
    git \
    wget \
    libicu-dev \
    libjpeg-progs \
    libpq-dev \
    libreadline-dev \
    libxml2-dev \
    libexpat1-dev \
    liblcms2-dev \
    libjpeg62-turbo-dev \
    libgif-dev \
    libpng-dev \
    libexif-dev \
    libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge   --auto-remove && \
    apt-get clean

# 3: Compile and install libvips
RUN cd /tmp; \
    wget -q https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz && \
    tar -xf vips-$VIPS_VERSION.tar.gz && \
    cd vips-$VIPS_VERSION && \
    ./configure --prefix=/usr && \
    make install && \
    rm -fr /tmp/vips-$VIPS_VERSION.tar.gz /tmp/vips-$VIPS_VERSION;

# Stage to download and build gems
FROM ruby:2.7.0-slim-buster AS gem-setup

# 3: Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    postgresql-client \
    pkg-config \
    libicu-dev \
    libjpeg-progs \
    libpq-dev \
    libreadline-dev \
    libxml2-dev \
    libexpat1-dev \
    liblcms2-dev \
    libjpeg62-turbo-dev \
    libgif-dev \
    libpng-dev \
    libexif-dev \
    libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge   --auto-remove && \
    apt-get clean && \
    gem install rails bundler;

WORKDIR /root

# 4a: copy Gemfile + lock, package + yarn.lock for ruby and node packages
COPY e621_code/Gemfile* e621_code/package.json e621_code/yarn.lock /root/

# Install broken gems (bundler doesn't like these)
# Install gemfile, Install bundler
RUN gem install nokogumbo -v '2.0.2' && \
    bundle install && \
    bundle check

# Stage to run e621
FROM ruby:2.7.0-slim-buster

# ENV definitions 
ENV	INSTALL_PATH=/app \
	DB_URL=sql \
	REDIS_URL=redis:6379 \
	RAILS_ENV=production \
	SECRET_TOKEN=09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e \
	SECRET_KEY=09fcf6c0075f2a331b807108f8a4a1bb6911ea168bb0407f4947372f1bcf7c5e \
	PGHOST=sql \
	PGUSER=root \
	PGPASSWORD=changethis

# 3: Install dependencies & node
RUN apt-get update && apt-get install --no-install-recommends -y wget ca-certificates gnupg; \
    wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list; \
    wget -qO - https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && apt-get install --no-install-recommends -y \
    nodejs \
    yarn \
    git \
    ffmpeg \
    libpq-dev \
    liblcms2-dev \
    libgif-dev \
    libexif-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge   --auto-remove && \
    apt-get clean

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

# Copy libvip files from vips-builder stage
COPY --from=vips-builder /usr/lib/libvips* /usr/lib/

# Copy gem files from gem-setup stage
COPY --from=gem-setup /usr/local/bundle/ /usr/local/bundle/

# Install modules and link libraries 
RUN yarn install && \
    yarn cache clean && \
    ldconfig

# Install shoreman
COPY shoreman.sh /usr/bin/shoreman

# Copy rest of the code
COPY e621_code /app

# Apply source patches
COPY patches/*.diff /app/patches/
RUN git apply /app/patches/*.diff && \
    apt-get purge -y git

# sed db and redis url
RUN sed -s "s/url: <%= .* %>/host: $DB_URL/g" script/install/database.yml.templ > config/database.yml && \
    sed -i "s/url: <%= .* %>/url: $REDIS_URL/g" config/cable.yml

# CP config template
RUN cp script/install/danbooru_local_config.rb.templ config/danbooru_local_config.rb

# Set up token + key
RUN mkdir -p ~/.danbooru && \
    echo $SECRET_TOKEN > ~/.danbooru/secret_token && \
    echo $SECRET_KEY > ~/.danbooru/session_secret_key && \
    chmod -R 600 ~/.danbooru;

# Webpack compile
RUN rails assets:precompile && \
    yarn cache clean && \
    rm -rf node_modules && \
    apt-get purge -y --auto-remove nodejs yarn && \
    apt-get clean

# Set up wait
COPY wait /wait

# Run startup script
COPY run.sh /run.sh
CMD /wait && /run.sh
