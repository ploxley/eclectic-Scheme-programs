# An Eclectic Collection of Scheme Programs
Scheme is a minimal Lisp that supports functional, imperative, and meta programming paradigms. 

Scheme was used in the seminal MIT Computer Science Lecture Series [Structure and Interpretation of Computer Programs](https://ocw.mit.edu/courses/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video_galleries/video-lectures/) presented by Abelson and Sussman, as well as the excellent [The Little Schemer](https://mitpress.mit.edu/9780262560993/the-little-schemer/) Book Series by Friedman et al.

This repository is a work-in-progress. Currently, it contains two contributions.

### 1. An application of relational programming to Discrete Mathematics
This contribution illustrates the idea of metalinguistic abstraction (solving complex problems by creating a new language to model the problem space) using the relational language miniKanren. It contains programs for logical inference that can be queried with the user interface from [The Reasoned Schemer](https://mitpress.mit.edu/9780262535519/the-reasoned-schemer/). 

To run the code, install an implementation of Scheme (Racket is easy to use), and type `(load "relational-programming-for-DM.scm")` on the command line of the interpreter (REPL). It is then possible to perform the following queries.

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

These logic relations can be used to generate critical rows of truth tables for valid and invalid argument forms.

Find the critical rows for modus ponens

`> (run* r (modus-ponens r))`

`'((1 1 1))`

Modus ponens has one critical row, and the conclusion is true (given by the final digit) when the premises are true (given by the earlier digits), therefore it is a valid argument form. On the other hand,

`> (run* r (converse-error r))`

`'((1 1 1) (1 1 0))`

and we see that converse error has two critical rows. The conclusion in the second row is false when the premises are true, so this argument form is invalid. 

Similarly, we can look at the rules of inference, such as  

`> (run* r (elimination r))`

`'((1 1 1))`

or

`> (run* r (division-into-cases r))`

`'((1 1 1 1) (1 1 1 1) (1 1 1 1))`

to confirm (from their critical rows) that they all have valid argument forms. There are many other cool things that can be done with this approach.

### 2. Finite Automatons, Turing Machines, and Interpreters

This contribution illustrates finite automatons, pushdown automatons, Turing machines, and the abstract idea of an interpreter (one that is not metacircular: i.e., a Lisp interpreter written in Lisp). It uses the imperative paradigm to change the state of two stack data structures (implemented as Scheme lists) to model an infinite tape in a Turing machine. 

Two alternative approaches to computation include the following. In [Introduction to the Theory of Computation](https://au.cengage.com/c/introduction-to-the-theory-of-computation-3e-sipser/9781133187790/), Sipser adopts the approach of defining a machine that recognizes a language (i.e., it accepts all strings of the language). While in [Turing Computability] (https://link.springer.com/book/10.1007/978-3-642-31933-4), Soare adopts the more historical approach of defining a machine that returns the output of a partial function. Here, we implement examples from Sipser's text because they can be implemented more simply. 

To illustrate a finite automaton (Example 1.21 from Sipser) accepting all strings that contain the substring $\texttt{001}$, type 

`> (load "finite-automaton.scm")`

which returns with

`"Please enter a string"`

Typing

`"0000100"`

leads to

`"accept"`

On the other hand, typing

`"10000"`

leads to

`"reject"`

To illustrate a deterministic pushdown automaton (Example 2.14 from Sipser) that accepts strings of the form $\{0^n1^n|\ n\geq 0\}$, type 

`(load "pushdown-automaton.scm")`

to get

`"Please enter a string"`

In order to check the stack is doing the right thing during the computation, it is necessary to start and end the string with "9". Typing

`"9000011119"`

leads to

`"accept"`

On the other hand, typing

`"900001119"`

leads to

`"reject"`

To illustrate a Turing machine (Example 3.9 from Sipser) that accepts strings of the form 

$\{w \# w|\ w\in \{0,1\}^*\}$, type 

`> (load "TM.scm")`

to get

`"Please enter a list"`

Now a Scheme list must be used; i.e., typing

`'(0 1 hash 0 1 blank)`

leads to

`'accept`

Note the use of `hash` for a hash symbol, and `blank` for a blank space in the list. Typing

`'(0 1 hash 1 0 blank)`

leads to

`'reject`

The final example is a Turing machine programmed as an interpreter for a finite automaton. Basically, this means the Turing machine simulates a finite automaton computing on its input. This is the first step towards implementing a Universal Turing Machine; that is, a Turing machine that can simulate a Turing machine computing on its input.

As an example, type

`> (set! *dfa-input* '(0 0 0 0 1 0 0))`

for the finite automaton's input, corresponding to the string `"0000100"`. Typing

`> (load "TM-interpreter.scm")` 

and 

`> (simulate)`

leads to

`'accept`

Now try 

`> (set! *dfa-input* '(1 0 0 0 0))`

followed by 

`> (load "TM-interpreter.scm")` 

and 

`> (simulate)`

as before. Now you should see

`'reject`

This completes the short demonstration.
