#! /bin/bash

while true; do
  test=$(gpio read 6)
  echo $test
done
