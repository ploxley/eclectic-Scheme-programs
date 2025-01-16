; The relational programming language miniKanren (taken from The Reasoned Schemer) 
; is used here to implement the rules of logical inference taught
; in a standard course on Discrete Mathematics. This is a direct
; illustration of metalinguistic abstraction as taught in SICP.

; Firstly, load "trs2-impl.scm" to access miniKanren and 
; the Reasoned Schemer user interface.

(load "trs2-impl.scm")

; The input-output table for a NAND gate is a Boolean relation:

(defrel (bool-nand p q r)
  (conde
   ((== p 1) (== q 1) (== r 0))
   ((== p 1) (== q 0) (== r 1))
   ((== p 0) (== q 1) (== r 1))
   ((== p 0) (== q 0) (== r 1))))

; From NAND, all other logic relations can be defined:

(defrel (bool-not p r)
  (bool-nand p p r))

(defrel (bool-and p q r)
  (fresh (z)
	 (bool-nand p q z)
	 (bool-not z r)))

(defrel (bool-or p q r)
  (fresh (x y)
	 (bool-not p x)
	 (bool-not q y)
	 (bool-nand x y r)))

(defrel (bool-if-then p q r)
  (fresh (x)
	 (bool-not p x)
	 (bool-or x q r)))

(defrel (bool-iff p q r)
  (fresh (x y)
	 (bool-if-then p q x)
	 (bool-if-then q p y)
	 (bool-and x y r)))

; Logic relations can be used to generate valid and invalid argument forms:

(defrel (modus-tollens r)
  (fresh (p q x)
	 (bool-if-then p q 1)
	 (bool-not q 1)
	 (bool-not p x)
	 (== r `(1 1 ,x))))

(defrel (modus-ponens r)
  (fresh (q)
	 (bool-if-then 1 q 1)
	 (== r `(1 1 ,q))))

(defrel (converse-error r)
  (fresh (p)
	 (bool-if-then p 1 1)
	 (== r `(1 1 ,p))))

(defrel (inverse-error r)
  (fresh (p q x)
	 (bool-if-then p q 1)
	 (bool-not p 1)
	 (bool-not q x)
	 (== r `(1 1 ,x))))

(defrel (generalization r)
  (fresh (q)
	 (bool-or 1 q 1)
	 (== r `(1 1))))

(defrel (specialization r)
  (fresh (q)
	 (bool-and 1 q 1)
	 (== r `(1 1))))

(defrel (elimination r)
  (fresh (p q)
	 (bool-or p q 1)
	 (bool-not q 1)
	 (== r `(1 1 ,p))))

(defrel (transitivity z)
  (fresh (p q r x)
	 (bool-if-then p q 1)
	 (bool-if-then q r 1)
	 (bool-if-then p r x)
	 (== z `(1 1 ,x))))

(defrel (division-into-cases z)
  (fresh (p q r)
	 (bool-or p q 1)
	 (bool-if-then p r 1)
	 (bool-if-then q r 1)
	 (== z `(1 1 1 ,r))))

(defrel (contradiction-rule r)
  (fresh (p x)
	 (bool-not p x)
	 (bool-if-then x 0 1)
	 (== r `(1 ,p))))
   
; Examples of queries using The Reasoned Schemer user interface:

; truth table for AND
; (run* (p q r) (bool-and p q r))
; truth values that make OR true
; (run* (p q) (bool-or p q 1))
; truth table for NOT IF-THEN
;; (run* (p q r)
;;       (fresh (x)
;; 	     (bool-if-then p q x)
;; 	     (bool-not x r)))
; generate the critical rows for modus ponens
; (run* r (modus-ponens r))

  
	 
