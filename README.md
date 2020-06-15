# E621 docker images

These are docker images that allow you to deploy an instance of E621 with... relative ease.

## Instructions

### Prerequisites

- Have docker installed.

### Configuration

1. Copy `env.example` to `.env`. Optionally, change NGINX_PORT if you want to run the service on a different port.
2. Copy `core/danbooru_local_config.example.rb` to `core/danbooru_local_config.rb`. This file can be used to override any setting in [here](https://github.com/zwagoth/e621ng/blob/master/config/danbooru_default_config.rb). Make sure to check below for the values you _can't_ change (docker overrides a couple in order to make E621 talk to the network's redis, memcached and elasticsearch containers).
3. Create your data folders. If you're using the default configuration, this will be in the `data` folder locally. Make sure that the elasticsearch scratch space (in default configuration, this is `./data/es`) has been set to be read/write for everywhere.
4. Set `vm.overcommit_memory=1` and `vm.max_map_count=262144` in `/etc/sysctl.conf` to make redis and elasticsearch work. (If you have a `/etc/sysctl.d` folder, make a new file called `docker.conf` and add them in there). To temporarily raise it for the current session, run `sysctl -w vm.max_map_count=262144` and `sysctl -w vm.overcommit_memory=1` as root.
5. Run `docker-compose pull` to pull in the redis, memcached and elasticsearch containers.
6. Run `docker-compose build --pull` to build the core, postgres and frontend containers. Also, get a cup of coffee, this will take a while.
7. Run `docker-compose up` to bring up the images. On the first run, the database will be initialized, which takes a few minutes.
8. Success

### Updating

To update the redis, memcached and elasticsearch containers, run `docker-compose pull`. To update the core, postgres and frontend containers, check below.

1. Run `docker-compose build --pull --no-cache`. This regenerates the containers with the latest e621 source code, postgres version and nginx version.
2. Run `docker-compose run --rm core rake db:migrate` to run the database migrations.
3. Run `docker-compose up` to bring up the images again.

### Note

* The first user you create will automatically be given administrator privileges.

## Changes from mainline E621 source code

* SSL disable patch: Disables the forced SSL that E621 normally has.
* Uploader accepts 0 tags: This changes the JS uploader to not demand tags to be placed on an image.
* `sed` in `core/cable.yml`: An inline patch to make E621 talk to the redis container server.
* Hostname patch to make mock services use the frontend instead of failing.
* Patch to artist forms to remove linked users from artists (it relies on missing table fields).

## Things you can't change in local_config

The following values should _not_ be overriden by the local_config file.

* `elasticsearch_host`
* `ssl_options`
* `memcached_servers`
* `redis_url`

## Credits

* The lovely people from StackOverflow, ElasticSearch community forums and various Ruby on Rails support communities for providing the resources.
* The various developers of E621s source code.
* A dishonorable credit to the developers of Danbooru for using Ruby on Rails and having broken migrations rot in the codebase.
* An _exceptionally_ dishonorable credit to the developers of Ruby on Rails for making an awful bloated mess of a library that is terrible to troubleshoot.

## TODO

Pull Requests for these are welcome.

* Optimize images
* Reduce amount of stages. Especially in core.
* Move compilation of libvips to it's own build stage.
* Move secret_key and secret_token out of core and make them build arguments.
* Build script that takes care of creating data folder in the right way and sets up the env file.
* Finding a way to keep a version of the E621 source code that works in the repository, rather than cloning the latest each time in the container.

