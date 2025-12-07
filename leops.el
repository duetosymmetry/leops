;;; leops.el --- Style hook for Leo's leops document class.  -*- lexical-binding: t; -*-

;;; Code:

(require 'tex)
(require 'latex)

(defun LaTeX-parse-addexercisepath ()
  "Parse the current document for \\addexercisepath commands.
Return value is a list of paths."
  (let ((results '())
        (exercisepath-regex "\\\\addexercisepath{\\({\\([^}]*\\)}\\)*}")
        (single-path-regex "{\\([^{}]*\\)}"))
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (while (re-search-forward exercisepath-regex nil t)
          (let ((full-match (match-string 0))
                (start-pos (match-beginning 0))
                (end-pos (match-end 0)))
            (save-excursion
              (goto-char start-pos)
              (while (re-search-forward single-path-regex end-pos t)
                (push (match-string-no-properties 1) results)))))
        (nreverse results)))))

(defvar LaTeX-leops-package-options-list
  '(;; Uni and course info
    ("schoolname")
    ("deptname")
    ("coursename")
    ("coursenum")
    ("termyear")
    ("instructor")
    ;; Problem set info
    ("psnum")
    ("psdue")
    ;; Show solutions or not
    ("solutions" ("true" "false"))
    ;; Show "used" commands or not
    ("used" ("true" "false")))
  "Package options for the leops package.")

(TeX-add-style-hook
 "leops"
  (lambda ()
    (TeX-run-style-hooks "article" "geometry" "amsmath" "amssymb"
                         "amsfonts" "amsthm" "xcolor" "tabularx"
                         "fontenc" "inputenc" "enumitem" "fancyhdr"
                         "hyperref" "graphicx" "bm" "verbatim"
                         "caption" "mdframed" "tikz" "siunitx"
                         "fifo-stack")
    (TeX-add-symbols
     '("pssetup" (TeX-arg-key-val LaTeX-leops-package-options-list))
     '("showsolutions" 0)
     '("hidesolutions" 0)
     '("ifsolutions" t)
     '("ifnotsolutions" t)
     '("used" t)
     '("addexercisepath" t)
     '("makeheader" 0)
     '("workpage" 0)
     '("exerstartswithlist" 0)
     '("points" t)
     '("pointsTable" 0)
     '("bs" t)
     '("pd" 0)
     '("nn" 0)
     '("cd" 0)
     '("avg" t)
     '("diag" 0)
     '("sign" 0)
     '("sech" 0)
     '("sinc" 0)
     '("arcsinh" 0)
     '("poiss" 2)
     '("dd" 0)
     '("Tr" 0))
    (LaTeX-add-environments
     '("exercise" ["Title (default is empty)"])
     '("solution" ["Label (default is 'Solution:')"]))
    ))

;;; leops.el ends here.
