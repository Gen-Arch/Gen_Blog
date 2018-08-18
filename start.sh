#!/bin/sh

bundle exec ruby gen_blog.rb > log/$(date +%Y%m%d_%H%M%S)_gen_blog.log 2>&1 &
echo $! > pid/gen_blog.pid
PID=`cat pid/gen_blog.pid`
echo "sinatra start (PID:$PID)"
