#!/bin/bash

git fetch origin master:$1 && git checkout $1
