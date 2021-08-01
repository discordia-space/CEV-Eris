#!/bin/bash

#Run this in the repo root after compiling
#First arg is path to where you want to deploy
#creates a work tree free of everything except what's necessary to run the game

#second arg is working directory if necessary
if [[ $# -eq 2 ]] ; then
  cd $2
fi

#i do not know why but this clean folder has a config "file." Fucking disgusting.
rm -rf $1/config/

mkdir -p \
    $1/maps \
    $1/strings \
	$1/config/names/

if [ -d ".git" ]; then
  mkdir -p $1/.git/logs
  cp -r .git/logs/* $1/.git/logs/
fi

cp cev_eris.dmb cev_eris.rsc $1/
cp -r maps/* $1/maps/
cp -r strings/* $1/strings/
cp -r config/names/* $1/config/names/
#remove .dm files from _maps

#this regrettably doesn't work with windows find
#find $1/_maps -name "*.dm" -type f -delete

#dlls on windows
if [ "$(uname -o)" = "Msys" ]; then
	cp ./*.dll $1/
fi
