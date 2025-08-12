#!/bin/bash

# Script to find truly unreferenced images in Jekyll blog
# Usage: ./find_unreferenced_images.sh [blog_directory]
# 
# This script analyzes a Jekyll blog to find images that are not referenced
# anywhere in the content, including:
# - Multilingual content (_i18n directories)
# - Draft posts (_drafts directory)
# - Dynamic galleries (gallery/ and selfies/ directories are auto-included)
# - YAML frontmatter image references
# - Markdown image syntax with case-insensitive file extensions

# Get script directory and set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="${1:-$(dirname $(dirname "$SCRIPT_DIR"))}"
RESULTS_DIR="$SCRIPT_DIR/results"

echo "=== Finding Unreferenced Images in Jekyll Blog ==="
echo "Blog directory: $BLOG_DIR"
echo "Results directory: $RESULTS_DIR"
echo

# Create results directory
mkdir -p "$RESULTS_DIR"

# Step 1: Get all image files
echo "Step 1: Collecting all image files..."
find "$BLOG_DIR/assets" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) | \
    sed "s|$BLOG_DIR/||" | \
    sort > "$RESULTS_DIR/all_images.txt"

total_images=$(wc -l < "$RESULTS_DIR/all_images.txt")
echo "Found $total_images total images"

# Step 2: Find all image references in content
echo
echo "Step 2: Finding image references in content files..."
> "$RESULTS_DIR/all_references.txt"

# 2a. Multilingual content with case-insensitive pattern
echo "  - Searching _i18n directories..."
find "$BLOG_DIR/_i18n" -name "*.md" -exec grep -iho '/\?assets/[^)"[:space:]]*\.\(jpg\|jpeg\|png\|gif\|webp\|svg\)' {} + 2>/dev/null | \
    sed 's|^/||' >> "$RESULTS_DIR/all_references.txt"

# 2b. Drafts 
echo "  - Searching _drafts directory..."
find "$BLOG_DIR/_drafts" -name "*.md" -exec grep -iho '/\?assets/[^)"[:space:]]*\.\(jpg\|jpeg\|png\|gif\|webp\|svg\)' {} + 2>/dev/null | \
    sed 's|^/||' >> "$RESULTS_DIR/all_references.txt"

# 2c. Main content files
echo "  - Searching main content files..."
find "$BLOG_DIR" -maxdepth 2 -name "*.md" -o -name "*.html" -o -name "*.yml" | \
    grep -v "_i18n" | grep -v "_drafts" | grep -v "_site" | \
    xargs grep -iho '/\?assets/[^)"[:space:]]*\.\(jpg\|jpeg\|png\|gif\|webp\|svg\)' 2>/dev/null | \
    sed 's|^/||' >> "$RESULTS_DIR/all_references.txt"

# 2d. Dynamic galleries (case-insensitive)
echo "  - Including dynamic gallery images..."
find "$BLOG_DIR/assets/images/gallery" -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" | \
    sed "s|$BLOG_DIR/||" >> "$RESULTS_DIR/all_references.txt"
find "$BLOG_DIR/assets/images/selfies" -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" | \
    sed "s|$BLOG_DIR/||" >> "$RESULTS_DIR/all_references.txt"

# Clean up references
sort "$RESULTS_DIR/all_references.txt" | uniq > "$RESULTS_DIR/clean_references.txt"
referenced_count=$(wc -l < "$RESULTS_DIR/clean_references.txt")
echo "Found $referenced_count unique image references"

# Step 3: Find unreferenced images
echo
echo "Step 3: Finding unreferenced images..."
comm -23 "$RESULTS_DIR/all_images.txt" "$RESULTS_DIR/clean_references.txt" > "$RESULTS_DIR/unreferenced_images.txt"
unreferenced_count=$(wc -l < "$RESULTS_DIR/unreferenced_images.txt")

# Step 4: Results
echo
echo "=== RESULTS ==="
echo "Total images: $total_images"
echo "Referenced images: $referenced_count"
echo "Unreferenced images: $unreferenced_count"
echo
echo "Files created in $RESULTS_DIR:"
echo "- all_images.txt (all image files)"
echo "- clean_references.txt (all references found)"
echo "- unreferenced_images.txt (unreferenced images)"

# Test if known examples are found
echo
echo "=== VERIFICATION ==="
echo -n "moiposudu.jpg referenced? "
if grep -q "moiposudu" "$RESULTS_DIR/clean_references.txt"; then
    echo "✓ YES"
else
    echo "✗ NO"
fi

echo -n "DSCF0480.jpg referenced? "
if grep -q "DSCF0480" "$RESULTS_DIR/clean_references.txt"; then
    echo "✓ YES"
else
    echo "✗ NO"
fi

echo -n "IMG_3409.JPG referenced? "
if grep -q "IMG_3409" "$RESULTS_DIR/clean_references.txt"; then
    echo "✓ YES"
else
    echo "✗ NO"
fi

if [ $unreferenced_count -gt 0 ]; then
    echo
    echo "First 5 unreferenced images:"
    head -5 "$RESULTS_DIR/unreferenced_images.txt"
fi

echo
echo "Analysis complete. Results saved in: $RESULTS_DIR"