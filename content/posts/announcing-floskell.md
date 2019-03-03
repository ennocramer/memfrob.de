+++
title = "Announcing Floskell"
date = 2019-01-25
description = "Floskell, a new Haskell Source Code Formatter"

[taxonomies]
categories = [ "Programming"]
tags = [ "Haskell", "Code Formatting" ]

[extra]
author = "Enno Cramer"
+++
Floskell is a new Haskell source code formatter.

Floskell tries to be *flexible*, meaning that the user should be able
to tune the output to match their personal style preference.  To
achieve this goal, Floskell defines a number of orthogonal formatting
options and applies these consistently to all Haskell language
constructs.

Floskell is hosted on
[GitHub](https://github.com/ennocramer/floskell). To get a quick
impression of how Floskell output looks, check out the [style demo /
test
harness](https://github.com/ennocramer/floskell/tree/master/styles).
Or check out the [configuration
file](https://github.com/ennocramer/floskell/blob/master/floskell.json)
used by Floskell itself.

## History

Floskell started as a fork of version 4 of HIndent, back in mid-2016,
simply to keep my personal formatting style alive.  As I tried to push
that style to better handle various edge cases, it became clear that
the existing pretty printing infrastructure was not sufficiently
flexible to support my goals.

The formatting styles of HIndent have been preserved in spirit, but
generally will not produce exactly the same output.  The last version
to have the original formatting styles (modulo bug fixes) available is
in the `classic` branch.

## Comparison to Other Tools

* **HIndent**: HIndent defines a canonical formatting style, while
  Floskell tries to support many different styles.

* **Brittany**: Floskell seems to have a similar approach to using the
  available horizontal space, while giving more explicit formatting
  control.

* **stylish-haskell**: Floskell is built to reformat entire modules,
  including all declarations.

## Core Concepts

A style in Floskell is a set of formatting possibilities for different
language constructs.  Floskell formats Haskell code according to a
given style by finding the combination of allowed formatting choices
that result in the best overall layout.

### Penalty

The overall layout of the generated output is judged by a penalty
function.  This function takes into account the number of lines
generated, whether lines are longer than a defined limit, and the
indentation of each line.

In general, Floskell will try to generate

* the smallest number of lines,

* the least amount of indentation, and

* the least amount of overflow.

### Layout

A number of language constructs can be formatted in different ways.
Floskell generally defines two layout choices for these constructs,
`flex` and `vertical`, and three modes to apply these choices, `flex`,
`vertical`, and `try-oneline`.

The layout choice `flex` generally tries to fit as much on each line
as possible, but allows linebreaks in a number of places, while the
`vertical` layout choice forces linebreaks in various places.

The `flex` and `vertical` layout modes simply select the respective
layout choice, while `try-oneline` will first try `flex`, but replace
the choice with `vertical` if the `flex` layout would more than one
line or an overfull line.

An example:

```haskell
-- flex layout for con-decls
data Enum = One | Two | Three

-- vertical layout for con-decls
data Enum = One
          | Two
          | Three
```

### Indentation

A number of language constructs can apply indentation to sub-elements.
Floskell provides two different indentation choices, `aligned` and
`indented`, and three modes to apply these choices, `align`,
`indent-by n`, and `align-or-indent-by n`.

`align` will start the sub-element on the same line and raise the
indentation to align following lines, while `indent-by n` will start
the sub-element on the following line with the indentation raised by
`n`.

`align-or-indent-by n` will allow either choice and select the
formatting with the least penalty.

An example:

```haskell
-- align for do
foo = do x <- xs
         y <- ys
         return (x, y)

-- indent-by 4 for do
foo = do
    x <- xs
    y <- ys
    return (x, y)
```

### Tabstop Alignment

Some language constructs allow for tabstop alignment.  Alignment is
optional and subject to configurable limits, regarding the amount of
added whitespace.

An example:

```haskell
-- let without alignment
let foo = bar
    quux = quuz
in foo quux

-- let with alignment
let foo    = bar
    quuuux = quuz
in foo quuuux
```

### Whitespace

Floskell allows the customization of whitespace around infix
operators, as well as inside parentheses and other enclosing
punctuation characters.

The presence of whitespace or linebreaks is as `before`, meaning
before the operator/enclosed item, `after`, meaning after the
operator/enclosed item, or `both`, meaning both before and after the
operator/enclosed item.

Whitespace configuration can depend on the context where an operator
or enclosing punctuation is used.  The context can be one of
`declaration`, `type`, `pattern`, `expression`, or `other`.

An example:

```haskell
-- tuple with space after/before parentheses and after comma
tuple = ( 1, 2 )
-- tuple without any spaces
tuple = (1,2)
```

## Benchmark

Floskell can be quite slow.  I have made a good effort to keep runtime
acceptable, but large and complex expressions may take a while to
format.

The formatting algorithm is not always linear in the size of the
input, though I have made an effort to avoid most cases of
super-linear runtime.  If you might run into cases where Floskell
requires an extraordinary amount of time, please open an issue.

To give an impression of the expected runtime, I have benchmarked
Floskell against both HIndent (v5.2.6) and brittany (0.11.0.0.x2), on
the worst-performing source files (for Floskell) in this project.  The
benchmarks have been performed on a 2012 MacBook Air (2 GHz Intel Core
i7) using [hyperfine](https://github.com/sharkdp/hyperfine).

### **src/Floskell/Pretty.hs**

A very large (2087 lines), but reasonably simple file.

```
Benchmark #1: floskell <src/Floskell/Pretty.hs >/dev/null
  Time (mean ± σ):      1.094 s ±  0.016 s    [User: 1.035 s, System: 0.043 s]
  Range (min … max):    1.076 s …  1.120 s    10 runs

Benchmark #2: hindent <src/Floskell/Pretty.hs >/dev/null
  Time (mean ± σ):     10.293 s ±  0.055 s    [User: 10.105 s, System: 0.124 s]
  Range (min … max):   10.191 s … 10.352 s    10 runs

Benchmark #3: brittany <src/Floskell/Pretty.hs >/dev/null
  Time (mean ± σ):      2.076 s ±  0.058 s    [User: 1.964 s, System: 0.091 s]
  Range (min … max):    2.018 s …  2.214 s    10 runs

Summary
  'floskell <src/Floskell/Pretty.hs >/dev/null' ran
    1.90 ± 0.06 times faster than 'brittany <src/Floskell/Pretty.hs >/dev/null'
    9.41 ± 0.15 times faster than 'hindent <src/Floskell/Pretty.hs >/dev/null'
```

### **src/Floskell/Comments.hs**

A very small (121 lines) file with a sufficiently complex expression
to cause Floskell to explore many formatting options.

```
Benchmark #1: floskell <src/Floskell/Comments.hs >/dev/null
  Time (mean ± σ):     386.1 ms ±   7.7 ms    [User: 355.4 ms, System: 18.6 ms]
  Range (min … max):   375.1 ms … 398.6 ms    10 runs

Benchmark #2: hindent <src/Floskell/Comments.hs >/dev/null
  Time (mean ± σ):      85.5 ms ±   6.5 ms    [User: 65.7 ms, System: 10.8 ms]
  Range (min … max):    76.6 ms … 102.7 ms    33 runs

Benchmark #3: brittany <src/Floskell/Comments.hs >/dev/null
  Time (mean ± σ):     212.6 ms ±   6.2 ms    [User: 173.6 ms, System: 27.8 ms]
  Range (min … max):   203.6 ms … 225.2 ms    13 runs

Summary
  'hindent <src/Floskell/Comments.hs >/dev/null' ran
    2.49 ± 0.20 times faster than 'brittany <src/Floskell/Comments.hs >/dev/null'
    4.52 ± 0.35 times faster than 'floskell <src/Floskell/Comments.hs >/dev/null'
```

## Missing Features and Known Issues

Floskell has a few known issues.  I am open to suggestions and/or
contributions to improve the situation.

* The configuration parser is built on `aeson` and has *extremely*
  poor error messages.

* The configuration format is very verbose.  More default values would
  make it easier to write custom configurations.

* I would like to extend the configuration for individual infix
  operators to include operator groups and the layout and indentation
  choice.  For example, I want to be able to format `$` and `.` in a
  `flex` manner, while applying `vertical` layout with `align`
  indentation to the `Functor` and `Applicative` operators (`<$>`,
  `<*>`, etc).

  ```haskell
  parser = KeyAgreement <$> getObject
                        <*> getExplicit 0
                        <*> getExplicitMaybe 1
                        <*> getObject
                        <*> getSequenceOf
  ```

* The `CPP` language extension is not well supported.  Floskell will
  split its input on preprocessor lines and reformat each chunk
  individually.  As such, each chunk must for a valid Haskell module
  by itself.
