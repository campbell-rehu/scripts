#!/bin/bash

verifyCommand() {
    if ! command -v $1 &> /dev/null
    then
        echo "<$1> could not be found"
    fi
}

verifyCommand "tmux"
verifyCommand "nvim"
verifyCommand "lvim"
