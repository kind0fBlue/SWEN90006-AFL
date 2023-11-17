#!/bin/bash

source_dir="/home/ubuntu/results/others/"
file1="movies1.txt"
file2="movies2.txt"
file3="topstream.c"

target_dir="/home/ubuntu/topstream/"

sudo mv "$source_dir$file1" "$target_dir"
sudo mv "$source_dir$file2" "$target_dir"
sudo mv "$source_dir$file3" "$target_dir"

