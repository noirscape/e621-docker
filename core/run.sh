if [ ! -f /app/public/data/ran_setup.txt ]; then
    echo "Creating database"
    bundle exec rake db:create
    echo "Running migrations"
    bundle exec rake db:migrate
    echo "Running setup"
    bin/setup
    touch /app/public/data/ran_setup.txt
fi

rm -rf /app/tmp/pids/*
/usr/bin/shoreman
