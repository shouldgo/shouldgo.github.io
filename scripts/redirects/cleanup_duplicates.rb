#!/usr/bin/env ruby

# Script to find and remove duplicate redirects
puts "🔍 FINDING DUPLICATE REDIRECTS..."
puts "=" * 50

redirect_files = Dir.glob("../../_redirects/*.md")
permalinks = {}
duplicates = []

# First pass: collect all permalinks
redirect_files.each do |file|
  content = File.read(file)
  if content.match(/permalink:\s*(.+)/)
    permalink = $1.strip
    if permalinks[permalink]
      duplicates << {
        permalink: permalink,
        original: permalinks[permalink],
        duplicate: file
      }
    else
      permalinks[permalink] = file
    end
  end
end

if duplicates.empty?
  puts "✅ No duplicate redirects found!"
else
  puts "❌ Found #{duplicates.size} duplicate redirects:"
  puts ""
  
  duplicates.each do |dup|
    puts "🔄 Permalink: #{dup[:permalink]}"
    puts "   Original: #{dup[:original]}"
    puts "   Duplicate: #{dup[:duplicate]}"
    
    # Check if files are identical
    original_content = File.read(dup[:original])
    duplicate_content = File.read(dup[:duplicate])
    
    if original_content == duplicate_content
      puts "   ✅ Files are identical - removing duplicate"
      File.delete(dup[:duplicate])
    else
      puts "   ⚠️  Files differ - manual review needed"
      puts "   Original content:"
      puts "   #{original_content.lines.first(3).join('   ')}"
      puts "   Duplicate content:"
      puts "   #{duplicate_content.lines.first(3).join('   ')}"
    end
    puts ""
  end
end

# Final count
final_count = Dir.glob("../../_redirects/*.md").length
puts "=" * 50
puts "📁 Final redirect count: #{final_count}"
puts "✅ Cleanup complete!"
