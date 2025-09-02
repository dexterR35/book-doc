#!/bin/bash

# Generate All Formats Script for Sync Book
# This script generates HTML, print PDF, and DOCX from the complete-book.md file

echo "🚀 SYNC - GENERATE ALL FORMATS"
echo "================================"
echo ""

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

echo "📚 Generating all formats from complete book..."
echo ""

# ============================================================================
# 1. GENERATE HTML
# ============================================================================
echo "🌐 STEP 1: Generating HTML..."
echo "--------------------------------"

# Create a cleaned version for HTML generation
cp ../build/complete-book.md ../build/complete-book-html.md

# Clean up formatting for HTML
sed -i '/^# Capitolul [0-9]*$/d' ../build/complete-book-html.md
sed -i 's/^## Prefață {.frontmatter}/## Prefață/g' ../build/complete-book-html.md
sed -i 's/^## Informații despre carte {.unnumbered .frontmatter}/## Informații despre carte/g' ../build/complete-book-html.md
sed -i 's/^# SYNC - Aplicație Full-Stack de Management al Sarcinilor {.frontmatter}/# SYNC - Aplicație Full-Stack de Management al Sarcinilor/g' ../build/complete-book-html.md

# Generate HTML
pandoc ../build/complete-book-html.md \
  -o "Sync_documentation.html" \
  --standalone \
  --toc \
  --number-sections \
  --top-level-division=chapter \
  --css=style.css

if [ -f "Sync_documentation.html" ]; then
    echo "✅ HTML generated: Sync_documentation.html ($(du -h Sync_documentation.html | cut -f1))"
else
    echo "❌ HTML generation failed!"
fi

# Clean up
rm ../build/complete-book-html.md

echo ""

# ============================================================================
# 2. GENERATE PRINT PDF
# ============================================================================
echo "🖨️  STEP 2: Generating Print PDF..."
echo "-----------------------------------"

# Create a cleaned version for print PDF
cp ../build/complete-book.md ../build/complete-book-print.md

# Clean up formatting for print PDF
sed -i '/^# Capitolul [0-9]*$/d' ../build/complete-book-print.md
sed -i 's/^## Prefață {.frontmatter}/## Prefață/g' ../build/complete-book-print.md
sed -i 's/^## Informații despre carte {.unnumbered .frontmatter}/## Informații despre carte/g' ../build/complete-book-print.md
sed -i 's/^# SYNC - Aplicație Full-Stack de Management al Sarcinilor {.frontmatter}/# SYNC - Aplicație Full-Stack de Management al Sarcinilor/g' ../build/complete-book-print.md

# Generate print PDF
pandoc ../build/complete-book-print.md \
  -o "Sync_documentation_PRINT.pdf" \
  --pdf-engine=xelatex \
  --toc \
  --number-sections \
  --top-level-division=chapter \
  -V geometry:margin=0.5in \
  -V fontsize=12pt \
  -V mainfont="Liberation Serif" \
  -V monofont="Liberation Mono" \
  -V colorlinks=false \
  -V documentclass=report \
  -V papersize=a4 \
  -V linestretch=1.1 \
  -V parskip=0.3em \
  -V header-includes="\\usepackage{fancyhdr}\\pagestyle{fancy}\\fancyhf{}\\fancyhead[L]{}\\fancyhead[R]{}\\renewcommand{\\headrulewidth}{0pt}\\usepackage{titlesec}\\titleformat{\\chapter}[display]{\\normalfont\\huge\\bfseries}{Capitolul\\ \\thechapter}{20pt}{\\Huge}" \
  -V include-in-header="\\usepackage{enumitem}\\setlist[itemize]{leftmargin=*}\\setlist[enumerate]{leftmargin=*}\\usepackage{booktabs}\\usepackage{longtable}\\usepackage{graphicx}\\usepackage{float}\\usepackage{framed}\\newenvironment{Shaded}{\\begin{shaded*}}{\\end{shaded*}}\\definecolor{shadecolor}{RGB}{240,240,240}\\usepackage{titlesec}\\titlespacing*{\\chapter}{0pt}{0.5ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\titlespacing*{\\section}{0pt}{0.5ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\titlespacing*{\\subsection}{0pt}{0.3ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\titlespacing*{\\subsubsection}{0pt}{0.3ex plus 0.1ex minus .1ex}{0.5ex plus .1ex}\\usepackage{geometry}\\geometry{top=0.5in,bottom=0.5in,left=0.5in,right=0.5in}\\setcounter{chapter}{0}"

if [ -f "Sync_documentation_PRINT.pdf" ]; then
    echo "✅ Print PDF generated: Sync_documentation_PRINT.pdf ($(du -h Sync_documentation_PRINT.pdf | cut -f1))"
else
    echo "❌ Print PDF generation failed!"
fi

# Clean up
rm ../build/complete-book-print.md

echo ""

# ============================================================================
# 3. GENERATE DOCX
# ============================================================================
echo "📄 STEP 3: Generating DOCX..."
echo "------------------------------"

# Create a cleaned version for DOCX
cp ../build/complete-book.md ../build/complete-book-docx.md

# Clean up formatting for DOCX
sed -i '/^# Capitolul [0-9]*$/d' ../build/complete-book-docx.md
sed -i 's/^## Prefață {.frontmatter}/## Prefață/g' ../build/complete-book-docx.md
sed -i 's/^## Informații despre carte {.unnumbered .frontmatter}/## Informații despre carte/g' ../build/complete-book-docx.md
sed -i 's/^# SYNC - Aplicație Full-Stack de Management al Sarcinilor {.frontmatter}/# SYNC - Aplicație Full-Stack de Management al Sarcinilor/g' ../build/complete-book-docx.md

# Generate DOCX
pandoc ../build/complete-book-docx.md \
  -o "Sync_documentation.docx" \
  --toc \
  --number-sections \
  --top-level-division=chapter \
  --metadata title="SYNC - Aplicație Full-Stack de Management al Sarcinilor" \
  --metadata author="Nae Ioana" \
  --metadata date="2025"

if [ -f "Sync_documentation.docx" ]; then
    echo "✅ DOCX generated: Sync_documentation.docx ($(du -h Sync_documentation.docx | cut -f1))"
else
    echo "❌ DOCX generation failed!"
fi

# Clean up
rm ../build/complete-book-docx.md

echo ""
echo "🎉 FINAL STATUS"
echo "==============="

# Check what was generated successfully
html_exists=false
print_pdf_exists=false
docx_exists=false

if [ -f "Sync_documentation.html" ]; then
    html_exists=true
    echo "✅ HTML: Sync_documentation.html ($(du -h Sync_documentation.html | cut -f1))"
fi

if [ -f "Sync_documentation_PRINT.pdf" ]; then
    print_pdf_exists=false
    echo "✅ Print PDF: Sync_documentation_PRINT.pdf ($(du -h Sync_documentation_PRINT.pdf | cut -f1))"
fi

if [ -f "Sync_documentation.docx" ]; then
    docx_exists=true
    echo "✅ DOCX: Sync_documentation.docx ($(du -h Sync_documentation.docx | cut -f1))"
fi

echo ""
if [ "$html_exists" = true ] && [ "$print_pdf_exists" = true ] && [ "$docx_exists" = true ]; then
    echo "🚀 All formats generated successfully!"
    echo "💡 You can now:"
    echo "   • Open HTML in any web browser"
    echo "   • Print the PDF with optimized margins"
    echo "   • Edit the DOCX in Word/LibreOffice"
else
    echo "⚠️  Some formats may have failed to generate"
    echo "💡 Check the output above for details"
fi

echo ""
echo "📋 Files created:"
ls -la *.html *.pdf *.docx 2>/dev/null | awk '{print "   • " $9 " (" $5 ")"}' || echo "   No files found"
