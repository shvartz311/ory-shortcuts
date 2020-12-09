#!/bin/bash

git fetch origin master:$1 && git checkout $1 && git push -u origin $1
