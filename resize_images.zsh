#!/bin/zsh

input_dir=~/selfies/
output_dir=~/selfies/res

mkdir -p "$output_dir"

# Enable extended globbing
setopt extended_glob

# Loop through image files
for img in "$input_dir"/*.(jpg|jpeg|png|JPG|JPEG|PNG); do
  # Get dimensions
  width=$(identify -format "%w" "$img" 2>/dev/null)
  height=$(identify -format "%h" "$img" 2>/dev/null)

  # Skip files ImageMagick can't read
  if [[ -z "$width" || -z "$height" ]]; then
    echo "Skipping unreadable: $img"
    continue
  fi

  # If both dimensions are <= 3000, copy without resizing
  if (( width <= 3000 && height <= 3000 )); then
    cp "$img" "$output_dir/"
  else
    # Resize based on longer side
    if (( width > height )); then
      convert "$img" -resize 3000x "$output_dir/$(basename "$img")"
    else
      convert "$img" -resize x3000 "$output_dir/$(basename "$img")"
    fi
  fi
done