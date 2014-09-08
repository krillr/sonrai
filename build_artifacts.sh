#!/bin/bash
wget --quiet https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
java -jar yuicompressor-2.4.8.jar --type js sonrai-bundle.js > sonrai.min.js
rm yuicompressor-2.4.8.jar
