if [ ! -f /app/public/data/ran_setup.txt ]; then
    echo "Creating database"
    bundle exec rake db:create
#    echo "Importing structure"
#    bundle exec rake db:structure:load
    echo "Running migrations"
    bundle exec rake db:migrate
    echo "Running setup"
    bin/setup
    touch /app/public/data/ran_setup.txt
fi

echo "Updating secret key in container"
echo $SECRET_KEY > ~/.danbooru/session_secret_key
echo "Updating secret token in container"
echo $SECRET_TOKEN > ~/.danbooru/secret_token
chmod -R 600 ~/.danbooru;

rm -rf /app/tmp/pids/*
/usr/bin/shoreman
