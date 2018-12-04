#!/bin/bash

# quit at first error
set -e

echo "Installing cf cli"
wget "https://cli.run.pivotal.io/stable?release=debian64&source=github" -v cf.tgz && tar -zxvf cf.tgz && rm cf.tgz
export PATH="$PATH:."
cf --version