+++
template = "project.html"
title = "WikiText"
description = "WikiText is the specification of a simple plain-text markup, a parser and various output module for this specification in Perl."

[extra]
repository = "https://memfrob.de/hg/wikitext"
+++
WikiText is the specification of a simple plain-text markup, a parser
and various output module for this specification in Perl. The markup
language is heavily inspired by common idioms used in email and IRC
communication. It's main feature is a pleasantly readable and writable
source.

The Perl implementation of WikiText has been integrated into the
[Podius CMS](http://migo.sixbit.org/software/podius/), and in fact,
most of this site is written in it.

The Perl Module is
[available from CPAN](http://search.cpan.org/~migo/wikitext-perl-1.01/).

## Features

WikiText supports most major text structuring and formatting elements:

- Sections
- Environments
  - Lists (ordered, unordered, description)
  - Quotations
  - Pre-formatted text
  - Code
- Text markup
  - Emphasis
  - Strong
  - Underline
  - Strike-through
  - Typewriter
- Tables
- References
- Links

Currently, WikiText supports the output formats

- HTML,
- Latex, and
- POD.

## Documentation

See the [WikiText Specification](/files/wikitext-specification.html) ([TXT](/files/wikitext-specification.txt)) for details.
