#!/bin/bash
cp sonrai.js $CIRCLE_ARTIFACTS
wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
java -jar yuicompressor-2.4.8.jar --type js sonrai.js > $CIRCLE_ARTIFACTS/sonrai.min.js
