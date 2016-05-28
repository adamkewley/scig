; Use pandoc to generate to convert the spec from its
; markdown representation to a PDF one
(defun generate-pdf-of-spec ()
  (interactive)
  (shell-command "pandoc -o /tmp/spec.pdf SPEC.md"))

; Update the spec pdf whenever the buffer is saved
(add-hook 'after-save-hook (lambda () (generate-pdf-of-spec))

; Generate an initial version of the spec
(generate-pdf-of-spec)

; Show the spec PDF
(shell-command "evince /tmp/spec.pdf &")
