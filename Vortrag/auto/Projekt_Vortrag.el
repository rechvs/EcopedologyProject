(TeX-add-style-hook
 "Projekt_Vortrag"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "xcolor=dvipsnames")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "ngerman")))
   (add-to-list 'LaTeX-verbatim-environments-local "semiverbatim")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "beamer"
    "beamer10"
    "beamerthemesplit"
    "babel"
    "roboto"
    "fixltx2e"
    "graphicx"
    "url"
    "xcolor"
    "calc"
    "tikz"
    "fp")
   (TeX-add-symbols
    '("myscalebox" ["argument"] 1)
    '("mycaption" 1))
   (LaTeX-add-counters
    "firstElement"
    "secondElement"
    "thirdElement"
    "fourthElement"
    "fifthElement"
    "sixthElement"
    "seventhElement"
    "eighthElement"
    "ninthElement"
    "tenthElement")
   (LaTeX-add-lengths
    "balancedcolumnwidth")
   (LaTeX-add-color-definecolors
    "letters"
    "boxes")))

