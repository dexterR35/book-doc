#!/bin/bash

# Fix Complete Book Script
# This script fixes YAML parsing issues in the complete-book.md file

echo "🔧 Fixing complete book formatting issues..."

# Check if the complete book exists
if [ ! -f "../build/complete-book.md" ]; then
    echo "❌ Error: complete-book.md not found in ../build/"
    echo "   Please run the build script first to create the complete book."
    exit 1
fi

# Create a backup
echo "💾 Creating backup..."
cp ../build/complete-book.md ../build/complete-book-backup.md

# Fix the formatting issues
echo "🧹 Cleaning up problematic formatting..."

# Remove leading empty lines and problematic characters
sed -i '/./,$!d' ../build/complete-book.md

# Remove any trailing empty lines
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' ../build/complete-book.md

# Ensure proper line endings
dos2unix ../build/complete-book.md 2>/dev/null || true

# Clean up any standalone chapter number lines
sed -i '/^# Capitolul [0-9]*$/d' ../build/complete-book.md

# Ensure preface sections are properly marked
sed -i 's/^## Prefață {.frontmatter}/## Prefață/g' ../build/complete-book.md
sed -i 's/^## Informații despre carte {.unnumbered .frontmatter}/## Informații despre carte/g' ../build/complete-book.md

# Mark the main title and preface sections as unnumbered for proper chapter counting
sed -i 's/^# SYNC - Aplicație Full-Stack de Management al Sarcinilor {.frontmatter}/# SYNC - Aplicație Full-Stack de Management al Sarcinilor/g' ../build/complete-book.md

# Remove any problematic YAML-like syntax
sed -i 's/{\.frontmatter}//g' ../build/complete-book.md
sed -i 's/{\.unnumbered}//g' ../build/complete-book.md

echo "✅ Complete book formatting fixed!"
echo "💡 You can now run any generation script:"
echo "   • ./generate-html.sh"
echo "   • ./generate-print-pdf.sh"
echo "   • ./install-pandoc.sh"
echo "   • ./generate-docx.sh"
echo ""
echo "📁 Backup saved as: ../build/complete-book-backup.md"
