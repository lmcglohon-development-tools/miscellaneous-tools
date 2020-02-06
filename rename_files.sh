#!/bin/bash

for f in `cat rename_files.txt`; do
  echo moving ${f}
  mv ${f} $(dirname ${f})/`basename ${f} .scss`.less
done;
