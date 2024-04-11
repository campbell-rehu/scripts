#!/usr/bin/env bash

# Based on the script from ThePrimeagen: https://youtu.be/hJzqEAf2U4I?si=25nAdIQ4mt3B6XkU
set -e

languages=`echo "go js lua rust c cpp haskell csharp" | tr " " "\n"`
core_utils=`echo "xargs awk sed grep ls tr cut mv cp ssh find" | tr " " "\n"`

language=`printf "$languages $core_utils\n" | fzf`

read -p "query: " query

curl `echo "cht.sh/$language/~$query"`
