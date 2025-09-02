#!/bin/bash

# Task Manager App - Complete Book Builder
# This script combines all markdown files into one comprehensive book

echo "🚀 Starting to build your complete Sync book..."

# Create build directory in parent folder
mkdir -p ../build

# Start building the complete book - start with cover page
echo "" > ../build/complete-book.md

# Add cover page first
if [ -f "../00-cover.md" ]; then
    cat ../00-cover.md >> ../build/complete-book.md
    echo "✅ Added: 00-cover.md (Cover Page)"
    echo "" >> ../build/complete-book.md
else
    echo "⚠️  Warning: 00-cover.md not found"
fi



# Add all chapters in order (files already contain their own chapter headers)
if [ -f "../01-introduction.md" ]; then
    cat ../01-introduction.md >> ../build/complete-book.md
    echo "✅ Added: 01-introduction.md (Chapter 1)"
else
    echo "⚠️  Warning: 01-introduction.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../02-project-setup.md" ]; then
    cat ../02-project-setup.md >> ../build/complete-book.md
    echo "✅ Added: 02-project-setup.md (Chapter 2)"
else
    echo "⚠️  Warning: 02-project-setup.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../03-backend-development.md" ]; then
    cat ../03-backend-development.md >> ../build/complete-book.md
    echo "✅ Added: 03-backend-development.md (Chapter 3)"
else
    echo "⚠️  Warning: 03-backend-development.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../04-authentication-security.md" ]; then
    cat ../04-authentication-security.md >> ../build/complete-book.md
    echo "✅ Added: 04-authentication-security.md (Chapter 4)"
else
    echo "⚠️  Warning: 04-authentication-security.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../05-frontend-architecture.md" ]; then
    cat ../05-frontend-architecture.md >> ../build/complete-book.md
    echo "✅ Added: 05-frontend-architecture.md (Chapter 5)"
else
    echo "⚠️  Warning: 05-frontend-architecture.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../06-task-management-kanban.md" ]; then
    cat ../06-task-management-kanban.md >> ../build/complete-book.md
    echo "✅ Added: 06-task-management-kanban.md (Chapter 6)"
else
    echo "⚠️  Warning: 06-task-management-kanban.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../07-file-handling-storage.md" ]; then
    cat ../07-file-handling-storage.md >> ../build/complete-book.md
    echo "✅ Added: 07-file-handling-storage.md (Chapter 7)"
else
    echo "⚠️  Warning: 07-file-handling-storage.md not found"
fi
echo "" >> ../build/complete-book.md

if [ -f "../08-deployment-scaling.md" ]; then
    cat ../08-deployment-scaling.md >> ../build/complete-book.md
    echo "✅ Added: 08-deployment-scaling.md (Chapter 8)"
else
    echo "⚠️  Warning: 08-deployment-scaling.md not found"
fi

# Add Bibliography last
echo "## Bibliography" >> ../build/complete-book.md
if [ -f "../bibliography.md" ]; then
    cat ../bibliography.md >> ../build/complete-book.md
    echo "✅ Added: bibliography.md"
else
    echo "⚠️  Warning: bibliography.md not found"
fi

echo "" >> ../build/complete-book.md
echo "---" >> ../build/complete-book.md
echo "" >> ../build/complete-book.md
echo "**Book Generation Complete!**" >> ../build/complete-book.md
echo "" >> ../build/complete-book.md
echo "Generated on: $(date)" >> ../build/complete-book.md
echo "Total files processed: $(ls ../*.md | wc -l)" >> ../build/complete-book.md

echo ""
echo "🎉 Complete book built successfully!"
echo "📖 Output: ../build/complete-book.md"
echo "📊 Total lines: $(wc -l < ../build/complete-book.md)"
echo "📁 All your MD files have been combined!"
echo "📚 Your Sync application is now a complete technical book!"
echo ""
echo "🚀 Next step: Install pandoc and generate PDF!"
echo "   Run: ./install-pandoc.sh"
