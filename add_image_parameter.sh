#!/bin/bash

# This script extracts the first image from Jekyll posts and adds an 'image:' parameter to the front matter

# Function to process a single post file
process_post() {
  local post_file="$1"
  echo "Processing: $post_file"
  
  # Check if the post already has an image parameter
  if grep -q "^image:" "$post_file"; then
    echo "  Already has image parameter, skipping."
    return
  fi
  
  # Create a backup of the file
  cp "$post_file" "${post_file}.bak"
  
  # Extract the first image URL using various patterns
  local first_image=""
  
  # Different file extensions to try
  for ext in jpg jpeg png gif webp; do
    # Try standard markdown image format
    if [ -z "$first_image" ]; then
      first_image=$(grep -m 1 -o "!\[[^]]*\]([^)].*\.$ext)" "$post_file" | sed -E "s/!\[[^]]*\]\(([^)]*)\)/\1/")
    fi
    
    # Try empty alt text
    if [ -z "$first_image" ]; then
      first_image=$(grep -m 1 -o "!\[\]([^)].*\.$ext)" "$post_file" | sed -E "s/!\[\]\(([^)]*)\)/\1/")
    fi
    
    # Try with bullet points
    if [ -z "$first_image" ]; then
      first_image=$(grep -m 1 -o "- !\[[^]]*\]([^)].*\.$ext)" "$post_file" | sed -E "s/- !\[[^]]*\]\(([^)]*)\)/\1/")
    fi
    
    # Try with bullet points and empty alt text
    if [ -z "$first_image" ]; then
      first_image=$(grep -m 1 -o "- !\[\]([^)].*\.$ext)" "$post_file" | sed -E "s/- !\[\]\(([^)]*)\)/\1/")
    fi
  done
  
  # Check if we found an image
  if [ -z "$first_image" ]; then
    echo "  No image found in post."
    # Remove backup since we're not making changes
    rm "${post_file}.bak"
    return
  fi
  
  echo "  Found first image: $first_image"
  
  # Create a temporary file for processing
  local temp_file=$(mktemp)
  
  # Process the file and add the image parameter to front matter
  awk -v img="$first_image" '
  BEGIN { in_front_matter = 0; added_image = 0; }
  {
    if ($0 ~ /^---/ && in_front_matter == 0) {
      # Start of front matter
      in_front_matter = 1;
      print $0;
    } else if ($0 ~ /^---/ && in_front_matter == 1) {
      # End of front matter - add image before this line if not added yet
      if (added_image == 0) {
        print "image: " img;
        added_image = 1;
      }
      # Print the closing front matter delimiter
      print $0;
      in_front_matter = 0;
    } else {
      # Regular line, just print it
      print $0;
    }
  }' "$post_file" > "$temp_file"
  
  # Check if the temporary file has content
  if [ -s "$temp_file" ]; then
    # Replace original file with the modified content
    mv "$temp_file" "$post_file"
    echo "  Updated front matter with image: $first_image"
    # Remove backup on success
    rm "${post_file}.bak"
  else
    # Something went wrong, restore from backup
    echo "  Error processing file, restoring from backup."
    mv "${post_file}.bak" "$post_file"
    # Make sure the temp file is gone
    [ -f "$temp_file" ] && rm "$temp_file"
  fi
}

# Main script
if [ -n "$1" ]; then
  # Process a specific post if provided as an argument
  process_post "$1"
else
  # Process all posts
  for post in /Users/shouldgo/Projects/repos/shouldgo.github.io/_posts/*.markdown; do
    process_post "$post"
  done
fi

echo "Done!"