#!/bin/bash

display_usage() {
    echo "Usage: $0 <non-negative integer (1-92)>"
    echo "Please provide a non-negative integer between 0 and 93 as an argument to generate the Fibonacci sequence."
}

fibonacci() {
    local n=$1
    local a=0
    local b=1
    local color_start=160
    local color_end=220
    local color_range=$((color_end - color_start))

    echo "Fibonacci sequence up to $n:"

    for (( i=0; i<n; i++ )); do
        if [ "$n" -gt 1 ]; then
            color=$((color_start + (i * color_range) / (n - 1)))
        else
            color=$color_start
        fi

        echo -ne "\033[38;5;${color}m$a \033[0m"
        local temp=$a
        a=$b
        b=$((temp + b))
    done
    echo
}

if [ -z "$1" ]; then
    echo "Error: No argument provided."
    display_usage
    exit 1
fi

if ! [[ $1 =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: The argument must be a positive integer greater than zero."
    display_usage
    exit 1
fi

if [ "$1" -gt 92 ]; then
    echo "Error: The argument must be 92 or less to avoid integer overflow."
    echo "This limitation is due to the maximum size of integers that Bash can handle."
    display_usage
    exit 1
fi

fibonacci $1
