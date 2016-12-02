(TeX-add-style-hook
 "Projekt_Herleitung_Elemente"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "ngerman") ("inputenc" "utf8") ("caption" "font={small}" "labelfont={bf}" "singlelinecheck={false}" "justification=centering") ("geometry" "a4paper" "margin=2.5cm") ("hyperref" "colorlinks=false") ("biblatex" "backend=biber" "bibstyle=bibstyle_HA" "citestyle=citestyle_HA" "natbib=false" "mcite=false" "sorting=nyt" "sortcase=false" "sortcites=true" "maxbibnames=99" "autocite=plain" "language=autobib" "hyperref=false" "urldate=long" "dateabbrev=false" "firstinits=true" "bibencoding=utf8")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "babel"
    "inputenc"
    "graphicx"
    "url"
    "float"
    "amsmath"
    "fontspec"
    "unicode-math"
    "textcomp"
    "caption"
    "geometry"
    "booktabs"
    "tabularx"
    "longtable"
    "amsthm"
    "enumitem"
    "calc"
    "hyperref"
    "setspace"
    "siunitx"
    "xcolor"
    "biblatex")
   (TeX-add-symbols
    "biband")
   (LaTeX-add-array-newcolumntypes
    "C"
    "L")))

