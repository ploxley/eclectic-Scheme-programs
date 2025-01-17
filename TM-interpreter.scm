; Turing machine that interprets its input,
; allowing it to simulate the finite automaton
; from Example 1.21 with a particular input string.

; Encoding of finite automaton:
; States {a,b,c,d}
; Input alphabet {0,1}
; Accepts all input strings with 001 as a substring
; Start State: a
; Accept State: d
; Transition function: delta(q,a) = r encoded as  '(D q a r)

(define *dfa-encoding* '(D a 1 a D a 0 b D b 1 a D b 0 c D c 1 d D c 0 c D d 1 d D d 0 d))
; (define *dfa-input* '(1 1 1 0 1 0 0 1)) ; if this is commented, need to define in REPL
(define *start* '(a))
(define *accept* '(d))
(define *tape* (append '(hash) *accept* '(hash) *dfa-input* '(hash)
		     *dfa-encoding* '(hash) *start* '(blank blank blank blank blank blank
							 blank blank blank blank)))

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

(define move-tape
  (lambda (x)
    (cond ((eq? x 'L)
	   ((stack-push! 'R) ((stack-pop! 'L))))
	  ((eq? x 'R)
	   ((stack-push! 'L) ((stack-pop! 'R)))))))

(define write-tape
  (lambda (w)
    ((stack-pop! 'R))
    ((stack-push! 'R) w)))

(define read-tape
  (lambda ()
    (car *stackR*)))

(define scan-tape
  (lambda (direction jumps symbol)
    (letrec ((loop
	      (lambda (n)
		(cond ((zero? n))
		      ((eq? (read-tape) symbol)
		       (move-tape direction)
		       (loop (sub1 n)))
		      (else
		       (move-tape direction)
		       (loop n))))))	   
      (loop jumps))))

(define scan-transition-function
  (lambda (state input)
    (scan-tape 'R 1 'D)
    (cond ((eq? (read-tape) state)
	   (move-tape 'R)
	   (cond ((eq? (read-tape) input)
		  (move-tape 'R)
		  (read-tape))
		 (else (scan-transition-function state input))))
	  (else (scan-transition-function state input)))))

(define read-state
  (lambda ()
    (scan-tape 'R 1 'blank)
    (move-tape 'L)
    (move-tape 'L)
    (let ((state (read-tape)))
      (scan-tape 'L 2 'hash)
      state)))

(define write-state
  (lambda (state)
    (scan-tape 'R 1 'blank)
    (move-tape 'L)
    (write-tape state)))

(define read-next-input
  (lambda ()
    (scan-tape 'L 1 'X)
    (move-tape 'R)
    (move-tape 'R)
    (let ((input (read-tape)))
      (write-tape 'X)
      input)))

(define read-first-input
  (lambda ()
    (scan-tape 'R 2 'hash)
    (let ((input (read-tape)))
      (write-tape 'X)
      input)))

(define scan-for-term
  (lambda (term)
    (letrec ((loop
	      (lambda ()
		(let ((input (read-tape)))
		  (cond ((eq? input term)
			 #t)
			((eq? input 'blank)
			 #f)
			(else
			 (move-tape 'R)
			 (loop)))))))
      (loop))))

(input-to-tape! *tape*)

;; TM Controller
(define simulate
  (lambda ()
    (let ((input (read-first-input)))
      (letrec ((loop
		(lambda ()
		  (cond ((eq? input 0)
			 (let ((state (read-state)))
			   (cond ((eq? state 'a)
				  (write-state (scan-transition-function 'a 0)))
				 ((eq? state 'b)
				  (write-state (scan-transition-function 'b 0)))
				 ((eq? state 'c)
				  (write-state (scan-transition-function 'c 0)))
				 ((eq? state 'd)
				  (write-state (scan-transition-function 'd 0))))))
			((eq? input 1)
			 (let ((state (read-state)))
			   (cond ((eq? state 'a)
				  (write-state (scan-transition-function 'a 1)))
				 ((eq? state 'b)
				  (write-state (scan-transition-function 'b 1)))
				 ((eq? state 'c)
				  (write-state (scan-transition-function 'c 1)))
				 ((eq? state 'd)
				  (write-state (scan-transition-function 'd 1)))))))
		  (set! input (read-next-input))
		  (cond ((eq? input 'hash)
			 (scan-tape 'L 1 'hash)
			 (cond ((eq? (read-tape) 'd) ; assuming only single accept state
				(scan-tape 'R 2 'hash)
				(if (scan-for-term 'd) 'accept 'reject))))
			(else (loop))))))
	(loop)))))






    
    
