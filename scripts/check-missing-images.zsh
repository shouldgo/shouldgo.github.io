#!/bin/zsh

SITE_DIR="_site"
missing=0
total=0

for html_file in $(find $SITE_DIR -name '*.html'); do
  img_srcs=($(sed -n 's/.*<img[^>]*src=["'\'']\([^"\'\'']*\)["'\''].*/\1/pI' $html_file))

  for img_src in $img_srcs; do
    ((total++))
    if [[ "$img_src" != http* && "$img_src" != //* ]]; then
      dir=$(dirname "$html_file")

      # If img_src starts with '/', treat it as relative to SITE_DIR
      if [[ "$img_src" == /* ]]; then
        img_path="$SITE_DIR$img_src"
      else
        img_path="$dir/$img_src"
      fi

      # Normalize path by removing /./ and resolving ../ parts
      # Using python for cross-platform path normalization (optional)
      normalized_path=$(python3 -c "import os,sys; print(os.path.normpath(sys.argv[1]))" "$img_path")

      if [[ ! -f "$normalized_path" ]]; then
        echo "Missing image in $html_file -> $img_src"
        ((missing++))
      fi
    fi
  done
done

echo "Checked $total images."
if (( missing == 0 )); then
  echo "All local images are available!"
else
  echo "Total missing images: $missing"
fi