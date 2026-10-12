; extends

; Bold the two values of a ternary so the eye stops on them.
; ecma is shared by javascript, typescript and tsx.
; A nested ternary is skipped here, because its own values get bold.
(ternary_expression
  consequence: (_) @ternary.value
  (#not-kind-eq? @ternary.value "ternary_expression"))

(ternary_expression
  alternative: (_) @ternary.value
  (#not-kind-eq? @ternary.value "ternary_expression"))
