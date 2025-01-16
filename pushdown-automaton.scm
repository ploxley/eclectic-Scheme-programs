; Deterministic Pushdown Automaton Example 2.14
; taken from "Introduction to the Theory of Computation"
; by Sipser. 

; States {q1,q2,q3q4}
; Input alphabet {0,1}
; Stack alphabet {0,$}
; Accepts all input strings 01, 0011, 000111, etc.
; Note that the string must start and end with a "9"
; to signify it starts and finishes correctly:
; i.e., "900119" is accepted.

(define *stack* '())

(define stack-push!
  (lambda (x)
    (set! *stack* (cons x *stack*))))

(define stack-pop!
  (lambda ()
    (let ((top (car *stack*)))
      (set! *stack* (cdr *stack*))
      top)))

(define transition-function
  (lambda (state input)
    (cond ((and (eq? state 'q1)
		(eq? input 9))
	   (stack-push! '$) 'q2)
	  ((and (eq? state 'q2)
		(eq? input 0))
	   (stack-push! 0) 'q2)
	  ((and (eq? state 'q2)
		(eq? input 1)
		(eq? (stack-pop!) 0))
	   'q3)
	  ((and (eq? state 'q3)
		(eq? input 1)
		(eq? (stack-pop!) 0))
	   'q3)
	  ((and (eq? state 'q3)
		(eq? input 9)
		(eq? (stack-pop!) '$))
	   'q4))))

(define start 'q1)
(define accept 'q4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Helper functions
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
