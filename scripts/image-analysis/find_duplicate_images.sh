#!/bin/bash

# Script to find duplicate image filenames in Jekyll blog
# Usage: ./find_duplicate_images.sh [blog_directory]
#
# This script analyzes image files to find duplicates by filename.
# It excludes:
# - Thumbnail directories (/thumbs/)
# - Gallery directory (/gallery/) - managed dynamically
# - Selfies directory (/selfies/) - managed dynamically
#
# Focus is on finding actual duplicates in dated directories and other content.

# Get script directory and set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="${1:-$(dirname $(dirname "$SCRIPT_DIR"))}"
RESULTS_DIR="$SCRIPT_DIR/results"

echo "=== Finding Duplicate Image Filenames ==="
echo "Blog directory: $BLOG_DIR"
echo "Results directory: $RESULTS_DIR"
echo

# Create results directory
mkdir -p "$RESULTS_DIR"

# Step 1: Get all image files with full paths (excluding thumbs, gallery, and selfies directories)
echo "Step 1: Collecting all image files (excluding thumbs, gallery, and selfies directories)..."
find "$BLOG_DIR/assets" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) | \
    grep -v "/thumbs/" | grep -v "/gallery/" | grep -v "/selfies/" > "$RESULTS_DIR/all_images_full_paths.txt"

total_images=$(wc -l < "$RESULTS_DIR/all_images_full_paths.txt")
echo "Found $total_images total images"

# Step 2: Find duplicate filenames
echo
echo "Step 2: Finding duplicate filenames..."

# Create a list of just filenames to find duplicates
basename -a $(cat "$RESULTS_DIR/all_images_full_paths.txt") | sort | uniq -d > "$RESULTS_DIR/duplicate_filenames.txt"
duplicate_count=$(wc -l < "$RESULTS_DIR/duplicate_filenames.txt")

echo "Found $duplicate_count duplicate filenames"

# Step 3: Create detailed duplicate report
echo
echo "Step 3: Creating detailed duplicate report..."
> "$RESULTS_DIR/duplicate_details.txt"

duplicate_groups=0
total_duplicate_files=0

while IFS= read -r filename; do
    if [ -n "$filename" ]; then
        duplicate_groups=$((duplicate_groups + 1))
        echo "=== DUPLICATE GROUP #$duplicate_groups: $filename ===" >> "$RESULTS_DIR/duplicate_details.txt"
        
        # Find all files with this name
        grep "/$filename$" "$RESULTS_DIR/all_images_full_paths.txt" | while IFS= read -r full_path; do
            relative_path=${full_path#"$BLOG_DIR/"}
            echo "  $relative_path" >> "$RESULTS_DIR/duplicate_details.txt"
        done
        echo "" >> "$RESULTS_DIR/duplicate_details.txt"
    fi
done < "$RESULTS_DIR/duplicate_filenames.txt"

# Step 4: Summary
echo
echo "=== RESULTS ==="
echo "Total images: $total_images"
echo "Duplicate filenames: $duplicate_count"
echo "Duplicate groups: $duplicate_groups"

# Count total files involved in duplicates
total_files_in_duplicates=$(while IFS= read -r filename; do
    grep -c "/$filename$" "$RESULTS_DIR/all_images_full_paths.txt"
done < "$RESULTS_DIR/duplicate_filenames.txt" | awk '{sum += $1} END {print sum}')

echo "Total files involved in duplicates: $total_files_in_duplicates"
echo "Potential space savings: $((total_files_in_duplicates - duplicate_count)) files could be removed"

echo
echo "Files created in $RESULTS_DIR:"
echo "- duplicate_details.txt (detailed duplicate report)"
echo "- duplicate_filenames.txt (just the duplicate filenames)"
echo "- all_images_full_paths.txt (all analyzed image paths)"

if [ $duplicate_count -gt 0 ]; then
    echo
    echo "First 5 duplicate groups:"
    head -20 "$RESULTS_DIR/duplicate_details.txt"
    
    echo
    echo "For complete results, see: $RESULTS_DIR/duplicate_details.txt"
fi

echo
echo "Analysis complete. Results saved in: $RESULTS_DIR"