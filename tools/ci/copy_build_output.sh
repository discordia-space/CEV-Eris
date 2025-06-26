#!/bin/bash

mkdir -p \
    $1/icons \
    $1/tgui/public \

cp cev_eris.dmb cev_eris.rsc $1/
cp -r icons/* $1/icons/
cp -r tgui/public/* $1/tgui/public/
