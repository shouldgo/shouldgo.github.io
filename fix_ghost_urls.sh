#!/bin/bash

# Script to replace __GHOST_URL__ placeholders with proper Jekyll URLs (relative paths)
# Usage: ./fix_ghost_urls.sh

# Find all posts with __GHOST_URL__ placeholder
files=$(grep -l "__GHOST_URL__" _posts/*.markdown)

for file in $files; do
  echo "Processing $file..."
  
  # Make a backup of the file
  cp "$file" "${file}.bak"
  
  # Replace all Ghost URL placeholders with the correct Jekyll URLs
  sed -i '' 's| __GHOST_URL__ /love-poland/| /2020/04/12/love-poland/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /prague-czechia/| /2020/04/19/prague-czechia/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /italia/| /2020/04/26/italia/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /petite-france/| /2020/05/03/petite-france/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /germania-75/| /2020/05/12/germania-75/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /2020/| /2020/01/13/2020/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /2k18/| /2019/01/07/2k18/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /2017-in-50-photos/| /2018/01/10/2017-in-50-photos/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /prague-t/| /2012/11/24/prague-t/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /prague-sights/| /2012/11/27/prague-sights/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /praga-the-end/| /2013/04/01/praga-the-end/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /cesky-krumlov/| /2013/03/25/cesky-krumlov/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /berlin-tt/| /2012/12/09/berlin-tt/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /kipr-1/| /2018/10/23/kipr-1/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /kipr-2/| /2018/11/07/kipr-2/|g' "$file"
  sed -i '' 's| __GHOST_URL__ /post-phuket/| /2018/04/23/post-phuket/|g' "$file"

  # Check if we still have any __GHOST_URL__ placeholders left
  if grep -q "__GHOST_URL__" "$file"; then
    echo "WARNING: File $file still has __GHOST_URL__ placeholders"
    grep -n "__GHOST_URL__" "$file"
  fi
done

echo "Replaced __GHOST_URL__ placeholders with correct Jekyll URLs"