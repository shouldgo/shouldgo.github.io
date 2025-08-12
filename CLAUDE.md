# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a multilingual Jekyll blog for Dima Afonin, deployed to GitHub Pages. The site features photography and travel content in both English and Russian, with a responsive design and image galleries.

## Development Commands

### Local Development
```bash
# Install dependencies
bundle install

# Serve the site locally with live reload
bundle exec jekyll serve

# Build the site for production
bundle exec jekyll build
```

### Jekyll Commands
- `bundle exec jekyll serve --drafts` - Include draft posts in development
- `bundle exec jekyll serve --livereload` - Enable live reloading
- `bundle exec jekyll build --destination _site` - Build to specific directory

## Architecture

### Multilingual Setup
- Uses `jekyll-multiple-languages-plugin` for i18n support
- Languages: English (default) and Russian
- Content structure:
  - `_i18n/en/` - English content
  - `_i18n/ru/` - Russian content  
  - `_i18n/en.yml` and `_i18n/ru.yml` - Translation files
- Posts support translation linking via `translation_key` frontmatter

### Content Structure
- **Posts**: Located in `_i18n/{lang}/_posts/` with YYYY-MM-DD-title format
- **Pages**: Static pages in `_i18n/{lang}/` directories
- **Layouts**: Jekyll layouts in `_layouts/` (default, home, page, post)
- **Includes**: Reusable components in `_includes/`
- **Gallery**: Photo collections organized by year in `assets/images/`

### Key Features
- **Responsive Design**: Custom Sass in `_sass/` with flexbox layouts
- **Image Galleries**: Custom gallery system with lightbox (GLightbox)
- **Pagination**: Uses `jekyll-paginate-v2` for post pagination
- **SEO**: Multiple SEO plugins and structured data
- **Redirects**: Custom redirect system in `_redirects/` collection

### Custom Components
- `post-card.html` - Blog post preview cards
- `gallery.html` - Photo gallery display
- `switcher.html` - Language switching
- `pagination.html` - Post navigation

### Asset Management
- **Styles**: Main styles in `assets/main.scss`, imports from `_sass/`
- **Images**: Organized in `assets/images/` by year and type
- **JavaScript**: Custom JS for theme toggle, language redirect, and gallery

### GitHub Pages Deployment
- Uses `github-pages` gem for GitHub Pages compatibility
- Automatic deployment on push to main branch
- Custom domain configured via `CNAME`

## File Organization

```
├── _config.yml          # Main Jekyll configuration
├── _i18n/              # Multilingual content
│   ├── en/             # English content
│   ├── ru/             # Russian content
│   ├── en.yml          # English translations
│   └── ru.yml          # Russian translations
├── _layouts/           # Jekyll page layouts
├── _includes/          # Reusable template components
├── _sass/              # Sass stylesheets
├── assets/             # Static assets (images, JS, CSS)
├── _redirects/         # Custom redirect collection
└── scripts/            # Management scripts (excluded from build)
```

## Content Management

### Adding New Posts
1. Create markdown file in appropriate language directory: `_i18n/{lang}/_posts/YYYY-MM-DD-title.md`
2. Use standard Jekyll frontmatter with title, date, tags, and optional image
3. For bilingual posts, use matching `translation_key` in frontmatter

### Managing Redirects
- Scripts in `scripts/redirects/` handle 404s from Google Search Console
- Redirects created as collection items in `_redirects/`

### Photo Galleries  
- Images stored in `assets/images/gallery/` and `assets/images/selfies/`
- Gallery pages use custom include with GLightbox integration