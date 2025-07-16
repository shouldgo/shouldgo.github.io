#!/usr/bin/env ruby
require 'csv'
require 'uri'

# Read the CSV file (use command line argument or default)
csv_file = ARGV[0] || 'new_http_urls.csv'
redirect_dir = '../../_redirects'

# Create redirects directory if it doesn't exist
Dir.mkdir(redirect_dir) unless Dir.exist?(redirect_dir)

# Read existing redirects to avoid duplicates
existing_redirects = {}
if Dir.exist?(redirect_dir)
  Dir.glob("#{redirect_dir}/*.md").each do |file|
    content = File.read(file)
    if content.match(/permalink:\s*(.+)/)
      existing_redirects[$1.strip] = true
    end
  end
end

def extract_slug(url)
  # Remove protocol and domain
  path = url.gsub(/^https?:\/\/[^\/]+/, '')
  
  # Extract slug from different patterns
  if path.match(/\/(\d{4})\/(\d{2})\/(\d{2})\/([^\/]+)\.html$/)
    # Date-based post: /2012/01/12/tomsk.html -> tomsk
    return $4
  elsif path.match(/\/([^\/]+)\.html$/)
    # Simple post: /kazantrip.html -> kazantrip
    return $1
  elsif path.match(/\/([^\/]+)\/?$/)
    # Directory-style: /praga-the-end/ -> praga-the-end
    return $1
  elsif path.match(/\/([^\/]+)\/index\.html$/)
    # Index file: /dresden-dolls/index.html -> dresden-dolls
    return $1
  else
    # Default: use the last part of the path
    parts = path.split('/').reject(&:empty?)
    return parts.last&.gsub(/\.html$/, '') || 'unknown'
  end
end

def create_redirect_filename(url)
  # Create a safe filename for the redirect
  path = url.gsub(/^https?:\/\/[^\/]+/, '')
  filename = path.gsub(/[^a-zA-Z0-9\-_]/, '-')
  filename = filename.gsub(/-+/, '-')
  filename = filename.gsub(/^-|-$/, '')
  "redirect-#{filename}.md"
end

def find_target_page(slug, site_dir = '../../_site')
  # Check if the Russian version exists
  ru_path = "#{site_dir}/ru/blog/#{slug}/"
  if File.exist?("#{ru_path}/index.html")
    return "/ru/blog/#{slug}/"
  end
  
  # Check for similar names (with variations)
  if Dir.exist?("#{site_dir}/ru/blog/")
    Dir.entries("#{site_dir}/ru/blog/").each do |entry|
      next if entry.start_with?('.')
      if entry.include?(slug) || slug.include?(entry)
        return "/ru/blog/#{entry}/"
      end
    end
  end
  
  # Return fallback to Russian homepage
  return "/ru/"
end

# Process the CSV (auto-detect separator)
puts "Processing new HTTP 404 URLs..."
puts "=" * 50

# Try to detect the separator
first_line = File.open(csv_file, &:readline)
separator = first_line.include?(';') ? ';' : ','

CSV.foreach(csv_file, headers: true, col_sep: separator) do |row|
  url = row['URL']
  next if url.nil? || url.empty?
  
  # Extract the path from the URL
  path = url.gsub(/^https?:\/\/[^\/]+/, '')
  
  # Skip if redirect already exists
  if existing_redirects[path]
    puts "⚠️  Skipping #{path} - redirect already exists"
    next
  end
  
  # Handle different URL patterns
  target = case path
  when /^\/tags\//
    # Tag pages -> Russian homepage
    "/ru/"
  when /^\/ru\//
    # Already Russian URLs that return 404 -> Russian homepage
    "/ru/"
  when /^\/index-old\//
    # Old index -> Russian homepage
    "/ru/"
  when /^\/(__GHOST_URL__\s*\/|__GHOST_URL__\s+\/)/
    # Ghost URLs - extract the slug after __GHOST_URL__
    clean_path = path.gsub(/^\/(__GHOST_URL__\s*\/|__GHOST_URL__\s+\/)/, '/')
    slug = extract_slug(clean_path)
    find_target_page(slug)
  else
    # Regular posts - extract slug and find target
    slug = extract_slug(path)
    find_target_page(slug)
  end
  
  # Create redirect file
  filename = create_redirect_filename(url)
  filepath = "#{redirect_dir}/#{filename}"
  
  # Avoid duplicate filenames
  counter = 1
  while File.exist?(filepath)
    base_filename = filename.gsub(/\.md$/, '')
    filepath = "#{redirect_dir}/#{base_filename}-#{counter}.md"
    counter += 1
  end
  
  # Write redirect file
  File.write(filepath, <<~REDIRECT)
    ---
    permalink: #{path}
    redirect_to: #{target}
    ---
  REDIRECT
  
  puts "✓ #{path} -> #{target}"
end

puts "\n" + "=" * 50
puts "Redirect generation complete!"
puts "Don't forget to rebuild the site: bundle exec jekyll build"
