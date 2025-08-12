# Image Analysis Scripts

This directory contains scripts to analyze image usage in the Jekyll blog, helping identify unused images and duplicates for potential space savings.

## Scripts

### `find_unreferenced_images.sh`

Finds images that are not referenced anywhere in the blog content.

**What it analyzes:**
- Multilingual content (`_i18n/en/` and `_i18n/ru/`)
- Draft posts (`_drafts/`)
- Main content files (root level `.md`, `.html`, `.yml`)
- YAML frontmatter `image:` fields
- Markdown image syntax `![](path)`
- Dynamic galleries (automatically includes all images in `gallery/` and `selfies/`)

**What it finds:**
- Images that exist in `assets/` but are never referenced
- Handles case-insensitive file extensions (`.jpg` vs `.JPG`)

**Usage:**
```bash
cd scripts/image-analysis
./find_unreferenced_images.sh [blog_directory]
```

If no directory is specified, it uses the blog root (two levels up from the script).

**Output files:**
- `results/unreferenced_images.txt` - List of unreferenced images
- `results/all_images.txt` - All images found
- `results/clean_references.txt` - All image references found

### `find_duplicate_images.sh`

Finds images with identical filenames that could be duplicates.

**What it analyzes:**
- All image files in `assets/` directory
- Excludes thumbnail directories (`/thumbs/`)
- Excludes dynamic galleries (`/gallery/` and `/selfies/`)
- Focuses on dated directories and other content where duplicates are problematic

**What it finds:**
- Images with identical filenames in different directories
- Groups duplicates together for easy review
- Calculates potential space savings

**Usage:**
```bash
cd scripts/image-analysis
./find_duplicate_images.sh [blog_directory]
```

**Output files:**
- `results/duplicate_details.txt` - Detailed report with all duplicate groups
- `results/duplicate_filenames.txt` - List of duplicate filenames
- `results/all_images_full_paths.txt` - All analyzed image paths

## Results Directory

Both scripts create a `results/` subdirectory in the same location as the scripts. This keeps all analysis results organized and easily accessible.

## Example Workflow

1. **Find unreferenced images:**
   ```bash
   ./find_unreferenced_images.sh
   # Review results/unreferenced_images.txt
   ```

2. **Find duplicate images:**
   ```bash
   ./find_duplicate_images.sh
   # Review results/duplicate_details.txt
   ```

3. **Review and clean up:**
   - Check if "unreferenced" images are actually needed
   - Decide which duplicates to remove
   - Remove files manually after verification

## Notes

- **Gallery and Selfies**: These directories are managed dynamically by Jekyll includes, so all images in them are considered "referenced"
- **Thumbnails**: Thumbnail directories contain auto-generated copies and are excluded from duplicate analysis
- **Case Sensitivity**: Scripts handle both `.jpg` and `.JPG` extensions properly
- **Multilingual**: Properly searches both English and Russian content

## Typical Results

Based on recent analysis:
- **Unreferenced images**: ~0 (excellent organization!)
- **Duplicate images**: ~111 duplicate filenames involving 228 files
- **Space savings potential**: ~117 files could be removed

Most duplicates are camera files (DSCF*.jpg) copied across different year directories, suggesting photos were reorganized over time.