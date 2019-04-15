#!/usr/bin/env ash
_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$rack" 2>/dev/null
}

trap _term SIGTERM

while nc -z 127.0.0.1 4567; do echo 'waiting for old server to finish...'; sleep 3; done
if [ "$1" -eq "leakcheck" ]
then
  valgrind --tool=memcheck --trace-children=yes bundle exec rackup -p 4567 -o 0.0.0.0 &
else
  bundle exec rackup -p 4567 -o 0.0.0.0 &
fi

rack=$!
wait "$rack"
