#!/bin/sh

PID=`cat pid/gen_blog.pid`

kill $PID  && echo "process kill $PID" && rm pid/gen_blog.pid
