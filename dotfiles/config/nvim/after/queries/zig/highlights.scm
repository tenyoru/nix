;; vim: ft=query
;; extends

; stock query tags struct/enum/union/opaque declarations the same as any
; other type reference (@type); split it out so only the declaration site
; can be accented, per tonsky.me/blog/syntax-highlighting
(variable_declaration
  (identifier) @type.definition
  "="
  [
    (struct_declaration)
    (enum_declaration)
    (union_declaration)
    (opaque_declaration)
  ])
