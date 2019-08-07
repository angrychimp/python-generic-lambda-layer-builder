#!/bin/bash

pip install -t /tmp/python/lib/python3.7/site-packages/ -r requirements.txt ${PREP_ARGS}
cd /tmp && pwd && zip -ry -x@/var/task/exclude.lst build.zip python/lib