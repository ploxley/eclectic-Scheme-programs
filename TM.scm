; Turing Machine Example 3.9
; taken from "Introduction to the Theory of Computation"
; by Sipser. 

; States {q1,...,q8,accept,reject}
; Input alphabet {0,1,hash}
; Stack alphabet {0,1,hash,x,blank}
; Accepts all input strings 01#01, 00001#00001, etc.
; Enter this as '(0 1 hash 0 1 blank), etc.

(define *stackL* '())
(define *stackR* '())

(define stack-push!
  (lambda (x)
    (lambda (y)
      (cond ((eq? x 'L)
	     (set! *stackL* (cons y *stackL*)))
	    ((eq? x 'R)
	     (set! *stackR* (cons y *stackR*)))))))

(define stack-pop!
  (lambda (x)
    (lambda ()
      (cond ((eq? x 'L)
	     (let ((top (car *stackL*)))
	       (set! *stackL* (cdr *stackL*))
	       top))
	    ((eq? x 'R)
	     (let ((top (car *stackR*)))
	       (set! *stackR* (cdr *stackR*))
	       top))))))

(define input-to-tape!
  (lambda (input)
    (set! *stackR* input)))

(define movetape
  (lambda (x)
    (cond ((eq? x 'L)
	   ((stack-push! 'R) ((stack-pop! 'L))))
	  ((eq? x 'R)
	   ((stack-push! 'L) ((stack-pop! 'R)))))))

(define writetape
  (lambda (w)
    ((stack-pop! 'R))
    ((stack-push! 'R) w)))

(define readtape
  (lambda ()
    (car *stackR*)))

(define transition-function
  (lambda (state)
    (let ((input (readtape)))
      (cond ((eq? state 'q1)
	     (cond ((eq? input 0)
		    (writetape 'x) (movetape 'R) 'q2)
		   ((eq? input 'hash)
		    (movetape 'R) 'q8)
		   ((eq? input 1)
		    (writetape 'x) (movetape 'R) 'q3)
		   (else 'reject)))
	    ((eq? state 'q2)
	     (cond ((or (eq? input 0) (eq? input 1))
		    (movetape 'R) 'q2)
		   ((eq? input 'hash)
		    (movetape 'R) 'q4)
		   (else 'reject)))
	    ((eq? state 'q3)
	     (cond ((or (eq? input 0) (eq? input 1))
		    (movetape 'R) 'q3)
		   ((eq? input 'hash)
		    (movetape 'R) 'q5)
		   (else 'reject)))
	    ((eq? state 'q4)
	     (cond ((eq? input 'x)
		    (movetape 'R) 'q4)
		   ((eq? input 0)
		    (writetape 'x) (movetape 'L) 'q6)
		   (else 'reject)))
	    ((eq? state 'q5)
	     (cond ((eq? input 'x)
		    (movetape 'R) 'q5)
		   ((eq? input 1)
		    (writetape 'x) (movetape 'L) 'q6)
		   (else 'reject)))
	    ((eq? state 'q6)
	     (cond ((or (eq? input 0) (eq? input 1) (eq? input 'x))
		    (movetape 'L) 'q6)
		   ((eq? input 'hash)
		    (movetape 'L) 'q7)
		   (else 'reject)))
	    ((eq? state 'q7)
	     (cond ((or (eq? input 0) (eq? input 1))
		    (movetape 'L) 'q7)
		   ((eq? input 'x)
		    (movetape 'R) 'q1)
		   (else 'reject)))
	    ((eq? state 'q8)
	     (cond ((eq? input 'x)
		    (movetape 'R) 'q8)
		   ((eq? input 'blank)
		    (movetape 'R) 'accept)
		   (else 'reject)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Apply transition function over string
(define process-input
  (lambda (input)
    (input-to-tape! input)
    (letrec ((loop
	      (lambda (state)
		(cond ((eq? state 'accept) 'accept)
		      ((eq? state 'reject) 'reject)
		      (else (loop (transition-function state)))))))
      (loop 'q1))))

; Console interface
(newline)
(print "Please enter a list")
(newline)
(process-input (cadr (read)))
