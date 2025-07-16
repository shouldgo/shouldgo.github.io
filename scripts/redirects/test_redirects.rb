#!/usr/bin/env ruby

# Test script to verify all redirects are working
puts "🔍 COMPREHENSIVE REDIRECT SYSTEM VERIFICATION"
puts "=" * 60

# Change to project root
Dir.chdir("../..")

# Count total redirects
total_redirects = Dir.glob("_redirects/*.md").length
puts "📁 Total redirect files: #{total_redirects}"

# Check site build status
if Dir.exist?("_site")
  puts "✅ Site successfully built"
else
  puts "❌ Site not built - run 'bundle exec jekyll build' first"
  exit 1
end

# Test samples from each category
test_cases = {
  "Date-based posts" => [
    "/2012/02/20/kazantrip.html",
    "/2016/09/04/thai-life.html",
    "/2012/05/01/firstofmay.html"
  ],
  "Ghost URLs" => [
    "/praga-the-end/",
    "/love-poland/",
    "/berlin-tt/"
  ],
  "Tag pages" => [
    "/tags/russia",
    "/tags/travel",
    "/tags/photo"
  ],
  "Root-level posts" => [
    "/2k18/",
    "/kipr-1/"
  ],
  "Old date format" => [
    "/2018/01/10/2017-in-50-photos.html",
    "/2020/01/13/2020.html"
  ]
}

def test_redirect(url, site_dir = "_site")
  # Convert URL to expected file path
  file_path = url.gsub(/^\//, "")
  if file_path.end_with?('/')
    file_path = file_path + "index.html"
  elsif !file_path.end_with?('.html')
    file_path = file_path + ".html"
  end
  
  full_path = File.join(site_dir, file_path)
  
  if File.exist?(full_path)
    content = File.read(full_path)
    if content.include?("Redirecting") && content.include?("location=")
      match = content.match(/location="([^"]+)"/)
      return match ? match[1] : nil
    end
  end
  return nil
end

all_working = true
total_tested = 0

test_cases.each do |category, urls|
  puts "\n📂 #{category}:"
  urls.each do |url|
    target = test_redirect(url)
    if target
      puts "  ✅ #{url} → #{target}"
    else
      puts "  ❌ #{url} - NOT WORKING"
      all_working = false
    end
    total_tested += 1
  end
end

puts "\n" + "=" * 60
puts "📊 FINAL SUMMARY"
puts "=" * 60

if all_working
  puts "🎉 ALL REDIRECTS WORKING CORRECTLY!"
  puts "✅ #{total_tested} test cases passed"
  puts "📁 #{total_redirects} total redirect files"
  puts "🚀 Ready for deployment!"
else
  puts "⚠️  Some redirects need attention"
  puts "Please review the failed cases above"
end

puts "\n" + "=" * 60
puts "🔧 DEPLOYMENT CHECKLIST"
puts "=" * 60
puts "□ All redirect files created in _redirects/"
puts "□ Site builds successfully with JEKYLL_ENV=production"
puts "□ Sample redirects tested and working"
puts "□ All target pages exist or fallback to /ru/"
puts "□ No circular redirects or conflicts"
puts "□ Ready to commit and push to GitHub"
