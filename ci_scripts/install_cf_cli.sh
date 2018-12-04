#!/bin/bash

# quit at first error
set -e

echo "Installing cf cli"
wget "https://cli.run.pivotal.io/stable?release=${rel}&source=github" -qO cf.tgz && tar -zxvf cf.tgz && rm cf.tgz
export PATH="$PATH:."
cf --version