#!/usr/bin/env python3

# This script is a Python pandoc filter that is designed to make the first
# letter of every chapter into a drop cap using the LaTeX lettrine package.

import panflute as pf

def create_dropcap(word: str) -> pf.RawInline:
    """
    Auxiliary function that when given a word as a string, it returns an
    appropriate pf.RawInline in LaTeX format to make it into a drop cap. We use
    the lettrine package in LaTeX which allows us to make dropcaps of lines=n
    size, and it takes the following arguments:
        \lettrine[lines=n]{first letter}{rest of the letters}
    """
    # Retrieve first letter and then all-but-first (i.e. rest of the) letters
    # of our given word.
    first_letter:  str = word[0]
    other_letters: str = word[1:]

    # Compose the dropcap using string formatting. Note: we escape curly braces
    # by doubling them. Hence there are three layers of curly brace.
    dropcap: pf.RawInline = pf.RawInline(
        text=f"\lettrine[lines=4]{{{first_letter}}}{{{other_letters}}}",
        format="latex"
    )

    return dropcap

def action(element, doc):
    """
    Python pandoc filter which converts the first word of every chapter into a
    drop cap. By searching through the pandoc AST document tree for elements
    that fulfil the following three criteria:
      1. Is a paragraph
      2. Has an index of 0 (i.e. is the first paragraph)
      3. Has the document root as it's parent (i.e. not within footnote or env)
    We can find the first paragraph of every chapter, and then modify it.
    """
    # For the first element of the document that is a paragraph:
    if isinstance(element.parent, pf.Doc) and isinstance(element, pf.Para) and element.index == 0:
        # Change the first word in that paragraph into a dropcap
        element.content[0] = create_dropcap(element.content[0].text)

def main(doc=None):
    return pf.run_filter(action, doc=doc)

if __name__ == '__main__':
    main()