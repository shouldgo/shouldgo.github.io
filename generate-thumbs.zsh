#!/bin/zsh

SOURCE_DIR="assets/images/gallery/"
THUMBS_DIR="${SOURCE_DIR}/thumbs"
THUMB_WIDTH=600

mkdir -p "$THUMBS_DIR"

for img in "$SOURCE_DIR"/*.(jpg|jpeg|png); do
  filename=$(basename "$img")
  convert "$img" \
    -resize "${THUMB_WIDTH}x${THUMB_WIDTH}^" \
    -gravity center \
    -extent ${THUMB_WIDTH}x${THUMB_WIDTH} \
    -quality 80 \
    "$THUMBS_DIR/$filename"
  echo "✔︎ $filename → square thumbnail"
done