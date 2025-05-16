# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a personal blog website built with Jekyll and hosted on GitHub Pages. The site belongs to Dima Afonin and contains posts about photography, travel, and personal experiences from 2009 onwards.

## Development Environment Setup

### Prerequisites

- Ruby (version recommended by GitHub Pages)
- Bundler gem
- Jekyll

### Installation

```bash
# Install dependencies from Gemfile
bundle install
```

## Common Commands

### Local Development

Start a local development server:

```bash
# Run local Jekyll server with live reload
bundle exec jekyll serve

# Run with draft posts visible
bundle exec jekyll serve --drafts
```

The site will be available at http://localhost:4000.

### Build Site

Generate the static site files:

```bash
# Generate production-ready site in _site directory
bundle exec jekyll build
```

## Repository Structure

Key directories:

- `_posts/`: Blog posts in markdown format (named YYYY-MM-DD-title.markdown)
- `_drafts/`: Unpublished draft posts
- `_layouts/`: HTML templates for different page types
- `_includes/`: Reusable HTML components
- `assets/`: Contains images and the main.scss stylesheet
- `_config.yml`: Main Jekyll configuration file

## Content Creation

### Creating New Posts

1. Create a new markdown file in `_posts/` with filename format: `YYYY-MM-DD-title.markdown`
2. Add front matter (YAML) at the top:

```yaml
---
layout: post
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +0000
categories: category-name
---
```

3. Write content in markdown format below the front matter

### Adding Images

1. Add image files to `assets/images/YYYY/MM/` directory
2. Reference in posts using markdown: `![Alt text](/assets/images/YYYY/MM/image.jpg)`

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch. The live site is accessible at: https://shouldgo.me

## Styling

The site uses a custom design based on the Minima theme. The main stylesheet is in `assets/main.scss`.

## Memories

- never offer to jekyll serve, I'll do it myself