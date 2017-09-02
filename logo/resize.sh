#! /bin/bash

mkdir -p ./resized-height20
for image in $(find images -type f -name "*.png")
do
    renamed=$(echo $image | sed s#images#resized-height20#)
    convert -resize x20 $image $renamed
done
