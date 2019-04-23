#!/bin/sh
if [ -n "$1" ]; then
    docker run --rm -ti -v $PWD:/webapp 865308221/vue:2.x $*
else
    docker run --rm -ti -v $PWD:/webapp 865308221/vue:2.x npm run build
fi
