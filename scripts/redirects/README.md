# Jekyll Redirect System Documentation

## Overview

This directory contains tools and documentation for managing redirects from old URLs to new Russian blog posts on shouldgo.me. The system processes 404 URLs from Google Search Console CSV reports and creates Jekyll redirect files.

## System Architecture

### Core Components

1. **_redirects/ Directory** - Contains all redirect files processed by jekyll-redirect-from
2. **scripts/redirects/ Directory** - Management scripts and tools
3. **jekyll-redirect-from Plugin** - GitHub Pages compatible redirect system

### How It Works

1. Google Search Console provides CSV reports of 404 URLs
2. Processing scripts analyze URLs and create redirect files
3. Jekyll builds static redirect pages that use meta refresh
4. GitHub Pages serves redirects to users and search engines

## Files in This Directory

### Processing Scripts

- **`process_new_redirects.rb`** - Main script for processing new CSV files
- **`cleanup_duplicates.rb`** - Removes duplicate redirect files
- **`test_redirects.rb`** - Comprehensive testing and verification

### CSV Files (Input Data)

- **`shouldgo_me_404_urls.csv`** - Original 404 URLs from Google Search Console
- **`shouldgo_me_http_urls.csv`** - HTTP variant 404 URLs
- **`shouldgo_me_additional_404s.csv`** - Additional 404 URLs discovered

### Generated Files

- **`missing_posts.txt`** - List of target posts that don't exist
- **`redirect_log.txt`** - Processing log with decisions made

## Usage Instructions

### Processing New 404 URLs

1. **Get CSV from Google Search Console**:
   - Go to Google Search Console
   - Navigate to Coverage > Excluded > Not found (404)
   - Export the list as CSV

2. **Process the CSV**:
   ```bash
   cd scripts/redirects
   ruby process_new_redirects.rb path/to/your/file.csv
   ```

3. **Clean up duplicates** (if needed):
   ```bash
   ruby cleanup_duplicates.rb
   ```

4. **Test the redirects**:
   ```bash
   ruby test_redirects.rb
   ```

5. **Build and deploy**:
   ```bash
   cd ../..
   JEKYLL_ENV=production bundle exec jekyll build
   git add .
   git commit -m "Add new redirects for 404 URLs"
   git push origin main
   ```

### URL Processing Rules

The system handles various URL patterns:

#### Date-based URLs
- `/2012/02/20/kazantrip.html` → `/ru/blog/kazantrip/`
- `/2016/09/04/thai-life.html` → `/ru/blog/thai-life/`

#### Ghost CMS URLs
- `/praga-the-end/` → `/ru/blog/praga-the-end/`
- `/love-poland/` → `/ru/blog/love-poland/`

#### Tag Pages
- `/tags/russia` → `/ru/` (Russian homepage)
- `/tags/travel` → `/ru/` (Russian homepage)

#### Root-level Posts
- `/2k18/` → `/ru/blog/2k18/`
- `/kipr-1/` → `/ru/blog/kipr-1/`

#### Fallback Behavior
- Missing posts redirect to `/ru/` (Russian homepage)
- Invalid URLs redirect to `/ru/` (Russian homepage)

### CSV Format Support

The system handles multiple CSV formats:

1. **Standard format**: `URL,Impressions,Clicks,CTR,Position`
2. **Semicolon-separated**: `URL;Impressions;Clicks;CTR;Position`
3. **Simple format**: Just URLs, one per line

## Script Details

### process_new_redirects.rb

**Purpose**: Process new CSV files and create redirect files

**Key Features**:
- Handles multiple CSV formats automatically
- Checks for existing redirects to avoid duplicates
- Validates target posts exist in the site
- Creates proper Jekyll redirect files with frontmatter
- Logs all decisions for review

**Usage**:
```bash
ruby process_new_redirects.rb <csv_file>
```

**Output**:
- Creates redirect files in `../../_redirects/`
- Generates `missing_posts.txt` for missing targets
- Creates `redirect_log.txt` with processing details

### cleanup_duplicates.rb

**Purpose**: Remove duplicate redirect files

**Key Features**:
- Scans all redirect files for duplicate permalinks
- Keeps the first occurrence of each permalink
- Provides detailed output of removed duplicates
- Safe operation with confirmation

**Usage**:
```bash
ruby cleanup_duplicates.rb
```

### test_redirects.rb

**Purpose**: Comprehensive testing of all redirects

**Key Features**:
- Tests sample redirects from each category
- Verifies Jekyll build succeeds
- Counts total redirect files
- Provides deployment checklist

**Usage**:
```bash
ruby test_redirects.rb
```

## Maintenance

### Regular Tasks

1. **Monthly CSV Processing**: Process new 404 URLs from Google Search Console
2. **Cleanup**: Run duplicate cleanup after processing multiple CSV files
3. **Testing**: Always test redirects before deployment
4. **Monitoring**: Check Google Search Console for new 404s

### Troubleshooting

#### Common Issues

1. **CSV Format Problems**:
   - Check if CSV uses semicolons instead of commas
   - Verify CSV has header row
   - Ensure URLs are in first column

2. **Missing Target Posts**:
   - Check `missing_posts.txt` for posts that don't exist
   - Verify blog post slugs match expected format
   - Update target paths if posts moved

3. **Duplicate Redirects**:
   - Run `cleanup_duplicates.rb` to remove duplicates
   - Check for multiple processing of same CSV file

4. **Build Errors**:
   - Verify Jekyll configuration includes redirects collection
   - Check for invalid frontmatter in redirect files
   - Ensure jekyll-redirect-from plugin is enabled

### File Structure

```
scripts/redirects/
├── README.md                       # This documentation
├── process_new_redirects.rb        # Main processing script
├── cleanup_duplicates.rb           # Duplicate removal
├── test_redirects.rb              # Testing and verification
├── shouldgo_me_404_urls.csv       # Original 404 URLs
├── shouldgo_me_http_urls.csv      # HTTP variant URLs
├── shouldgo_me_additional_404s.csv # Additional 404 URLs
├── missing_posts.txt              # Missing target posts
└── redirect_log.txt               # Processing log
```

## Configuration

### Jekyll Configuration

Ensure `_config.yml` includes:

```yaml
collections:
  redirects:
    output: true
    permalink: /:path/

plugins:
  - jekyll-redirect-from
```

### Production URL

All redirects use the production URL: `https://shouldgo.me`

This is automatically set when building with `JEKYLL_ENV=production`.

## Best Practices

1. **Always test before deployment** - Run `test_redirects.rb`
2. **Process CSVs promptly** - Don't let 404s accumulate
3. **Monitor Google Search Console** - Check for new 404s regularly
4. **Keep logs** - The `redirect_log.txt` helps with debugging
5. **Backup before major changes** - Git commit before processing large CSV files

## Support

For issues or questions:
1. Check the `redirect_log.txt` for processing details
2. Run `test_redirects.rb` for system verification
3. Review missing posts in `missing_posts.txt`
4. Verify Jekyll configuration and build process
