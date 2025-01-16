; Deterministic Finite Automaton Example 1.21
; taken from "Introduction to the Theory of Computation"
; by Sipser. 

; States {q,q0,q00,q001}
; Input alphabet {0,1}
; Accepts all input strings with 001 as a substring
; Enter as "0000100", etc.

(define transition-function
  (lambda (state input)
    (cond ((eq? state 'q) (if (eq? input 1) 'q 'q0))
	  ((eq? state 'q0) (if (eq? input 1) 'q 'q00))
	  ((eq? state 'q00) (if (eq? input 1) 'q001 'q00))
	  (else 'q001))))

(define start 'q)
(define accept 'q001)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Helper function
(define number-string->list
  (lambda (str)
    (map (lambda (char)
	   (string->number (string char)))
	 (string->list str))))

; Apply transition function over string
(define process-string
  (lambda (string start-state accept-state)
    (letrec ((loop
	      (lambda (state string)
		(cond ((null? string) state)
		      (else
		       (loop
			(transition-function state (car string))
			(cdr string)))))))
      (if (eq? (loop start-state string) accept-state)
	  "accept"
	  "reject"))))

; Console interface
(newline)
(print "Please enter a string")
(newline)
(process-string (number-string->list (read)) start accept)
