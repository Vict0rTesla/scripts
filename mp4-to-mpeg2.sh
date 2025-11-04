#!/bin/bash
# setup.sh

read -p "Enter project name: " project
mkdir -p "$project"/{input,output,language}

curl -fsSL https://raw.githubusercontent.com/Vict0rTesla/scripts/main/turnonbluetooth.sh -o "$project/convert.sh"
chmod +x "$project/convert.sh"
