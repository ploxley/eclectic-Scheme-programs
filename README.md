# An Eclectic Collection of Scheme Programs
Scheme is a minimal Lisp that supports functional, imperative, and meta programming paradigms. 

Scheme was used in the seminal MIT Computer Science Lecture Series [Structure and Interpretation of Computer Programs](https://ocw.mit.edu/courses/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video_galleries/video-lectures/) presented by Abelson and Sussman, as well as the excellent [The Little Schemer](https://mitpress.mit.edu/9780262560993/the-little-schemer/) Book Series by Friedman et al.

This repository is a work-in-progress. The plan is to update it over time. Currently, there are only two contributions.

### 1. An application of relational programming to Discrete Mathematics
This contribution illustrates the idea of metalinguistic abstraction (solving complex problems by creating a new language to model the problem space) using the relational language miniKanren. It contains programs for logical inference that can be queried with the user interface from [The Reasoned Schemer](https://mitpress.mit.edu/9780262535519/the-reasoned-schemer/). 

To run the code, install an implementation of Scheme (Racket is easy to use), and type `(load "relational-programming-for-DM.scm")` on the command line of the interpreter (REPL). It is then possible to perform the follow queries.

Find the truth table for AND

`> (run* (p q r) (bool-and p q r))`

`'((1 1 1) (1 0 0) (0 1 0) (0 0 0))`

Find all truth values that make OR true 

`> (run* (p q) (bool-or p q 1))`

`'((1 1) (1 0) (0 1))`

Find the truth table for NOT(IF-THEN)

```none
> (run* (p q r)
      (fresh (x)
	     (bool-if-then p q x)
	     (bool-not x r)))
```

`'((1 1 0) (1 0 1) (0 1 0) (0 0 0))`

These logic relations can be used to generate valid and invalid argument forms.

Find the critical rows for modus ponens

`> (run* r (modus-ponens r))`

`'((1 1 1))`

There is one critical row, and the conclusion is true when the premises are true, so modus ponens is a valid argument form. On the other hand,

`> (run* r (converse-error r))`

`'((1 1 1) (1 1 0))`

and we see that converse error has two critical rows. The conclusion in the second row is false when the premises are true, so this argument form is invalid. Similarly, we can look at the rules of inference, such as  

`> (run* r (elimination r))`

`'((1 1 1))`

or

`> (run* r (division-into-cases r))`

`'((1 1 1 1) (1 1 1 1) (1 1 1 1))`

to confirm (from their critical rows) that they all have valid argument forms.


### 2. A (very) preliminary attempt at developing a Universal Turing Machine

++imperative program that changes the state of two stack data structures to model an infinite tape in a TM.