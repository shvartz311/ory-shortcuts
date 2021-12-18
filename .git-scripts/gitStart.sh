#!/bin/zsh

source ~/.oh-my-zsh-custom/misc.zsh
git fetch origin $(git_remote_branch):$1 && git checkout $1 && git push -u origin $1
