#!/bin/bash

# Master Script: Generate Complete Task Manager App Dcoumentation

# This script runs the entire process: build book + install pandoc + generate PDF

echo "🎯 SYNC - COMPLETE DOCUMENTATION GENERATOR"
echo "================================================"
echo ""

# Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x build-complete-book.sh
chmod +x install-pandoc.sh

echo ""

# Step 1: Build the complete book
echo "📚 STEP 1: Building Complete Book"
echo "----------------------------------"
./build-complete-book.sh

echo ""

# Step 2: Install pandoc and generate PDF
echo "📖 STEP 2: Installing Pandoc and Generating PDF"
echo "-----------------------------------------------"
./install-pandoc.sh

echo ""

# Final status
echo "🎉 FINAL STATUS"
echo "==============="
if [ -f "../Sync_documentation.pdf" ]; then
    echo "✅ SUCCESS: Your book is ready!"
    echo "📖 File: Sync_documentation.pdf"
    echo "📊 Size: $(du -h ../Sync_documentation.pdf | cut -f1)"
    echo "📁 Location: $(pwd)/.."
    echo ""
    echo "🚀 You can now:"
    echo "   • Open the PDF in any PDF reader"
    echo "   • Share it with others"
    echo "   • Print it professionally"
    echo "   • Use it in your portfolio"
else
    echo "⚠️  PDF generation may have failed, but check the build directory:"
    echo "   • ../build/complete-book.md (combined markdown)"
    echo "   • Try manual PDF generation with: ./install-pandoc.sh"
fi

echo ""
echo "📋 Files created:"
echo "   • ../build/complete-book.md (combined markdown)"
echo "   • ../Sync_documentation.pdf (if successful)"
echo "   • ../build/ directory with intermediate files"
