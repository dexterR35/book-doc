#!/bin/bash

# HTML Generation Script for Sync Book
# This script generates a clean HTML version from the complete-book.md file

echo "🌐 Generating HTML from complete book..."

# Check if the complete book exists
if [ ! -f "../build/complete-book.md" ]; then
    echo "❌ Error: complete-book.md not found in ../build/"
    echo "   Please run the build script first to create the complete book."
    exit 1
fi

# Check if pandoc is available
if ! command -v pandoc &> /dev/null; then
    echo "❌ Error: Pandoc is not installed."
    echo "   Please run install-pandoc.sh first or install pandoc manually."
    exit 1
fi

# Generate HTML with clean styling
echo "🔄 Generating HTML..."
pandoc ../build/complete-book.md \
  -o "Sync_documentation.html" \
  --standalone \
  --toc \
  --number-sections \
  --top-level-division=chapter \
  --css=style.css \
  --metadata title="SYNC - Full-Stack Task Management Application" \
  --metadata author="Nae Ioana" \
  --metadata date="2025"

# Check if HTML was generated successfully
if [ -f "Sync_documentation.html" ]; then
    echo ""
    echo "✅ HTML generated successfully!"
    echo "🌐 File: Sync_documentation.html"
    echo "📊 Size: $(du -h Sync_documentation.html | cut -f1)"
    
    # Try to get line count
    echo "📄 Lines: $(wc -l < Sync_documentation.html)"
    
    echo ""
    echo "🚀 Your Sync book HTML is ready!"
    echo "💡 You can open it in any web browser"
else
    echo "❌ HTML generation failed!"
    echo "💡 Try running: pandoc --version"
fi
