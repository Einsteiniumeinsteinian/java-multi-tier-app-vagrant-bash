#! /bin/bash

echo 
mkdir application-directory
git clone -b main https://github.com/hkhcoder/vprofile-project.git application-directory

find . -maxdepth 1 -type f -not \( -name "README.md" -o -name "pom.xml" -o -name "src" \) -exec rm -f {} +
