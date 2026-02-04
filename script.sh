#!/bin/bash

output="output.txt"

> "$output"   # clear output file
input="input.txt"

while IFS= read -r line; 
do
# echo "$line"
    if [[ "$line" == *\"frame.time\"* || \
          "$line" == *\"wlan.fc.type\"* || \
          "$line" == *\"wlan.fc.subtype\"* ]]; then
        echo "$line" >>"$output"
    fi
done < input.txt 

