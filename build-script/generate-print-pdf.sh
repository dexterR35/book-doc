#!/bin/bash

# Print-Optimized PDF Generation Script
# This script generates a PDF optimized for printing with proper margins and layout

echo "🖨️  Generating print-optimized PDF..."

# Check if the complete book exists
if [ ! -f "../build/complete-book.md" ]; then
    echo "❌ Error: complete-book.md not found in ../build/"
    echo "   Please run the build script first to create the complete book."
    exit 1
fi

# Check if pandoc is available
if ! command -v pandoc &> /dev/null; then
    echo "❌ Error: Pandoc is not installed."
    exit 1
fi

# Create a cleaned version for printing
echo "🧹 Preparing content for printing..."
sed 's/[✅❌🏢📁🔧📦⚠️🎉📖📊📄🚀💡🧹🎯🏗🎨🔄🔐🗄🔒💼🌟❤❤️☁📱🤖▶]/•/g' ../build/complete-book.md > ../build/complete-book-print.md

# Clean up duplicate chapter titles
sed -i 's/^# Chapter \([0-9]*\): \(.*\)$/# \2/g' ../build/complete-book-print.md
sed -i '/^# Chapter [0-9]*$/d' ../build/complete-book-print.md

# Generate print-optimized PDFa
echo "🔄 Generating print-ready PDF..."
pandoc ../build/complete-book-print.md \
  -o "Sync_documentation_PRINT.pdf" \
  --pdf-engine=xelatex \
  --toc \
  --number-sections \
  -V geometry:margin=0.5in \
  -V fontsize=12pt \
  -V mainfont="Liberation Serif" \
  -V monofont="Liberation Mono" \
  -V colorlinks=false \
  -V documentclass=report \
  -V papersize=a4 \
  -V linestretch=1.1 \
  -V parskip=0.3em \
  -V header-includes="\\usepackage{fancyhdr}\\pagestyle{fancy}\\fancyhf{}\\fancyhead[L]{}\\fancyhead[R]{}\\renewcommand{\\headrulewidth}{0pt}" \
  -V include-in-header="\\usepackage{enumitem}\\setlist[itemize]{leftmargin=*}\\setlist[enumerate]{leftmargin=*}\\usepackage{booktabs}\\usepackage{longtable}\\usepackage{graphicx}\\usepackage{float}\\usepackage{framed}\\newenvironment{Shaded}{\\begin{shaded*}}{\\end{shaded*}}\\definecolor{shadecolor}{RGB}{240,240,240}\\usepackage{titlesec}\\titlespacing*{\\chapter}{0pt}{0.5ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\titlespacing*{\\section}{0pt}{0.5ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\titlespacing*{\\subsection}{0pt}{0.3ex plus 0.1ex minus .1ex}{0.3ex plus .1ex}\\titlespacing*{\\subsubsection}{0pt}{0.3ex plus 0.1ex minus .1ex}{0.3ex plus .1ex}\\usepackage{geometry}\\geometry{top=0.5in,bottom=0.5in,left=0.5in,right=0.5in}"

# Check if PDF was generated successfully
if [ -f "Sync_documentation_PRINT.pdf" ]; then
    echo ""
    echo "🎉 Print-optimized PDF generated successfully!"
    echo "🖨️  File: Sync_documentation_PRINT.pdf"
    echo "📊 Size: $(du -h Sync_documentation_PRINT.pdf | cut -f1)"
    echo "📄 Pages: $(pdfinfo Sync_documentation_PRINT.pdf 2>/dev/null | grep Pages | awk '{print $2}' || echo "Unknown")"
    echo ""
    echo "🚀 Your print-ready Sync book is ready!"
          echo "💡 Optimized for printing with:"
      echo "   • Ultra-compact margins (0.5 inch)"
      echo "   • Standard font size (11pt)"
      echo "   • Tight line spacing (1.1)"
      echo "   • Minimal paragraph spacing (0.2em)"
      echo "   • Ultra-minimal title spacing"
      echo "   • No colored links (print-friendly)"
      echo "   • Clean pages (no headers/footers)"
      echo "   • Minimal top padding (0.5 inch)"
else
    echo "❌ Print PDF generation failed!"
fi

# Clean up temporary file
rm ../build/complete-book-print.md
