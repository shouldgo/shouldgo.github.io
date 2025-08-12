# Internal Scripts

This directory contains internal scripts for managing various aspects of the Jekyll site.

## Subdirectories

### `redirects/`
Scripts for managing the redirect system that handles 404 URLs from Google Search Console.

- Process new 404 URLs from CSV reports
- Clean up duplicate redirects
- Test redirect functionality
- See `redirects/README.md` for detailed documentation

### `image-analysis/`
Scripts for analyzing image usage and finding optimization opportunities.

- Find unreferenced images that can be safely removed
- Identify duplicate images by filename for space savings
- Comprehensive analysis of multilingual Jekyll content
- See `image-analysis/README.md` for detailed documentation

## Future Additions

Other script categories can be added here as needed:

- `build/` - Build and deployment scripts
- `content/` - Content management scripts
- `analytics/` - Analytics and reporting scripts
- `seo/` - SEO optimization scripts

## Usage

Each subdirectory contains its own README with specific usage instructions.
