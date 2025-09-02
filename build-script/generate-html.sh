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

# Create a cleaned version for HTML generation
echo "🧹 Preparing content for HTML generation..."
cp ../build/complete-book.md ../build/complete-book-html.md

# Clean up any problematic characters or formatting
echo "🔧 Cleaning up formatting for HTML..."

# Remove leading empty lines and problematic characters
sed -i '/./,$!d' ../build/complete-book-html.md

# Remove any standalone chapter number lines
sed -i '/^# Capitolul [0-9]*$/d' ../build/complete-book-html.md

# Ensure preface sections are properly marked
sed -i 's/^## Prefață {.frontmatter}/## Prefață/g' ../build/complete-book-html.md
sed -i 's/^## Informații despre carte {.unnumbered .frontmatter}/## Informații despre carte/g' ../build/complete-book-html.md

# Mark the main title and preface sections as unnumbered for proper chapter counting
sed -i 's/^# SYNC - Aplicație Full-Stack de Management al Sarcinilor {.frontmatter}/# SYNC - Aplicație Full-Stack de Management al Sarcinilor/g' ../build/complete-book-html.md

# Generate HTML with clean styling
echo "🔄 Generating HTML..."
pandoc ../build/complete-book-html.md \
  -o "Sync_documentation.html" \
  --standalone \
  --toc \
  --number-sections \
  --top-level-division=chapter \
  --css=style.css

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
    echo "💡 Features:"
    echo "   • Romanian chapter titles (Capitolul 1, Capitolul 2, etc.)"
    echo "   • Table of Contents"
    echo "   • Numbered sections"
    echo "   • Professional styling with CSS"
else
    echo "❌ HTML generation failed!"
    echo "💡 Try running: pandoc --version"
fi

# Clean up temporary file
rm ../build/complete-book-html.md
