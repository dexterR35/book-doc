#!/bin/bash

# Pandoc Installation and PDF Generation Script
# This script installs pandoc and generates a PDF from your complete book

echo "🔧 Installing Pandoc and generating PDF..."

# Check if pandoc is already installed
if command -v pandoc &> /dev/null; then
    echo "✅ Pandoc is already installed!"
else
    echo "📦 Installing Pandoc..."
    
    # Detect OS and install pandoc
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            sudo apt-get update
            sudo apt-get install -y pandoc texlive-xetex texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y pandoc texlive-xetex
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y pandoc texlive-xetex
        else
            echo "⚠️  Could not detect package manager. Please install pandoc manually."
            echo "   Visit: https://pandoc.org/installing.html"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install pandoc
            brew install --cask mactex
        else
            echo "⚠️  Homebrew not found. Please install pandoc manually."
            echo "   Visit: https://pandoc.org/installing.html"
            exit 1
        fi
    else
        echo "⚠️  Unsupported OS. Please install pandoc manually."
        echo "   Visit: https://pandoc.org/installing.html"
        exit 1
    fi
fi

# Verify pandoc installation
if command -v pandoc &> /dev/null; then
    echo "✅ Pandoc installed successfully!"
    pandoc --version | head -n 1
else
    echo "❌ Pandoc installation failed!"
    exit 1
fi

# Check if the complete book exists
if [ ! -f "../build/complete-book.md" ]; then
    echo "⚠️  Complete book not found. Building it first..."
    ./build-complete-book.sh
fi

# Generate PDF
echo "📖 Generating PDF from complete book..."

# Create a cleaned version without problematic emoji characters
echo "🧹 Cleaning markdown content for PDF generation..."
# Also remove the specific heart emoji that's causing YAML issues
sed 's/[✅❌🏢📁🔧📦⚠️🎉📖📊📄🚀💡🧹🎯🏗🎨🔄🔐🗄🔒💼🌟❤❤️☁📱🤖▶]/•/g' ../build/complete-book.md > ../build/complete-book-clean.md

# Clean up formatting for better PDF generation
echo "🔧 Cleaning up formatting..."

# Clean up chapter formatting for better PDF generation
sed -i 's/^# Chapter \([0-9]*\): \(.*\)$/# \2/g' ../build/complete-book-clean.md

# Remove duplicate chapter titles (Chapter X and Chapter X: Title)
sed -i '/^# Chapter [0-9]*$/d' ../build/complete-book-clean.md









# Use the cleaned file directly for PDF generation
cp ../build/complete-book-clean.md ../build/complete-book-final.md

# Generate PDF with clean, simple layout
echo "🔄 Generating PDF..."
pandoc ../build/complete-book-final.md -o "Sync_documentation.pdf" \
  --pdf-engine=xelatex \
  --toc \
  --number-sections \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  -V mainfont="Liberation Serif" \
  -V monofont="Liberation Mono" \
  -V colorlinks=true \
  -V linkcolor=blue \
  -V urlcolor=blue \
  -V documentclass=report \
  -V papersize=a4 \
  -V linestretch=1.1 \
  -V parskip=0.3em \
  -V header-includes="\\usepackage{fancyhdr}\\pagestyle{fancy}\\fancyhf{}\\fancyhead[L]{}\\fancyhead[R]{}\\renewcommand{\\headrulewidth}{0pt}" \
  -V include-in-header="\\usepackage{enumitem}\\setlist[itemize]{leftmargin=*}\\setlist[enumerate]{leftmargin=*}\\usepackage{booktabs}\\usepackage{longtable}\\usepackage{graphicx}\\usepackage{float}\\usepackage{framed}\\newenvironment{Shaded}{\\begin{shaded*}}{\\end{shaded*}}\\definecolor{shadecolor}{RGB}{248,248,248}\\usepackage{titlesec}\\titlespacing*{\\chapter}{0pt}{2ex plus 0.5ex minus .1ex}{2ex plus .1ex}"

# If Liberation fonts failed, try with default fonts
if [ ! -f "Sync_documentation.pdf" ]; then
    echo "⚠️  Liberation fonts failed, trying with default fonts..."
    pandoc ../build/complete-book-final.md -o "Sync_documentation.pdf" \
      --pdf-engine=xelatex \
      --toc \
      --number-sections \
      --top-level-division=chapter \
      -V geometry:margin=1in \
      -V fontsize=11pt \
      -V colorlinks=true \
      -V linkcolor=blue \
      -V urlcolor=blue \
      -V documentclass=report \
      -V papersize=a4 \
      -V linestretch=1.1 \
      -V parskip=0.3em \
      -V header-includes="\\usepackage{fancyhdr}\\pagestyle{fancy}\\fancyhf{}\\fancyhead[L]{}\\fancyhead[R]{}\\renewcommand{\\headrulewidth}{0pt}" \
      -V include-in-header="\\usepackage{enumitem}\\setlist[itemize]{leftmargin=*}\\setlist[enumerate]{leftmargin=*}\\usepackage{booktabs}\\usepackage{longtable}\\usepackage{graphicx}\\usepackage{float}\\usepackage{framed}\\newenvironment{Shaded}{\\begin{shaded*}}{\\end{shaded*}}\\definecolor{shadecolor}{RGB}{248,248,248}"
fi

# Clean up temporary file
rm ../build/complete-book-clean.md
rm ../build/complete-book-final.md

# Check if PDF was generated successfully
if [ -f "Sync_documentation.pdf" ]; then
    echo ""
    echo "🎉 PDF generated successfully!"
    echo "📖 File: Sync_documentation.pdf"
    echo "📊 Size: $(du -h Sync_documentation.pdf | cut -f1)"
    echo "📄 Pages: $(pdfinfo Sync_documentation.pdf 2>/dev/null | grep Pages | awk '{print $2}' || echo "Unknown")"
    echo ""
    echo "🚀 Your Sync book is ready!"
else
    echo "❌ PDF generation failed!"
    echo "💡 Try generating HTML instead:"
    echo "   pandoc ../build/complete-book.md -o Sync_documentation.html --standalone --toc"
fi
