(TeX-add-style-hook
 "Projekt"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("report" "oneside" "a4paper" "12pt" "titlepage")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "english") ("inputenc" "utf8") ("geometry" "a4paper" "margin=2.5cm" "left=3.5cm") ("hyperref" "colorlinks=false") ("caption" "singlelinecheck={false}" "font={scriptsize}" "labelfont={bf}" "aboveskip=0pt") ("biblatex" "backend=biber" "bibstyle=/home/renke/DATEN02/Uni/Formatvorlagen/LaTeX/bibstyle_HA" "citestyle=/home/renke/DATEN02/Uni/Formatvorlagen/LaTeX/citestyle_HA" "natbib=false" "mcite=false" "sorting=nyt" "sortcase=false" "sortcites=true" "maxbibnames=99" "autocite=plain" "language=autobib" "hyperref=false" "urldate=long" "dateabbrev=false" "firstinits=true" "bibencoding=utf8")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "report"
    "rep12"
    "babel"
    "inputenc"
    "fixltx2e"
    "fontspec"
    "booktabs"
    "paralist"
    "setspace"
    "fancyhdr"
    "geometry"
    "hyperref"
    "csquotes"
    "tabularx"
    "caption"
    "siunitx"
    "textcomp"
    "graphicx"
    "floatrow"
    "enumitem"
    "calc"
    "upgreek"
    "unicode-math"
    "tikz"
    "chngcntr"
    "biblatex")
   (TeX-add-symbols
    "biband")
   (LaTeX-add-labels
    "#2")
   (LaTeX-add-environments
    '("mytable" 2))
   (LaTeX-add-lengths
    "ueberoben"
    "bildbreite"
    "capabstand")
   (LaTeX-add-array-newcolumntypes
    "C"
    "L"))
 :latex)

