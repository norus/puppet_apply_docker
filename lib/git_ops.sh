#!/usr/bin/env bash

# THIS FILE IS INTENDED TO BE SOURCED

clone() {
    git clone $1/$2\.git
}

checkout() {
    git checkout $1
}
