#!/bin/bash

echo "Installing cf cli"
if [[ ! -e bin/cf ]]; then
    mkdir -p bin/
    cd bin
    wget "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" -q -O cf.tgz && tar -zxvf cf.tgz && rm cf.tgz
    ./cf --version
    cd ..
fi