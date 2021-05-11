#!/bin/bash

while read line
do
  echo `code --install-extension $line`
done < extensions.txt
