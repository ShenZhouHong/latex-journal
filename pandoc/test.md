---
title: The Chapter Title
date: 2022-11-12
---

This is an example file that is used to test the custom markdown to LaTeX pandoc
filter.

# Level 1 Section Header 

Some additional test text in multiple paragraphs: Some text, some additional text
as well as more text going on.

Here is the start of a new paragraph with some additional text alongside with it.

## Level 2 Section Header

Numbered list of items:

1. Item number one
   potentially on multiple lines.

   asdf 
1. Item number two with *italics*
1. Item number three with **bold**

Bulleted list of items:

* First item
* *Second item*
* Third item with
  potentially multiple lines

  Here is the additional line
  

### Level 3 Section Header

Test for different text styles. Here is some **bold text**. Here is some
**italics** text. 

#### Level 4 Section Header

Test for quotations. Here is a text in quotes "testing one two three."

> Quotes that are formatted like this. This is **BOLD**. This is *italics*

And here are more quotes, that are now formatted like a block quote:

> Quotes in a blockquote MULTILINE
>
> that are on multiple lines
>
> This is **BOLD**. This is *italics*
>
> going on like this.

# Footnote tests

Here is some text, and a footnote on this mark[^1]

A paragraph in between with some random filler content.

Additionally, this should be the example of a margin note using an inline footnote in markdown. The inline footnote will begin on this mark^[Inline notes are easier to write, since
you don't have to pick an identifier and move down to type the
note.]

A paragraph in between with some random filler content.

[^1]: Here is the content text of the aforementioned footnote. With some **bold** and some **italics** within it as well.

# Code block tests

```python
# Comment
print("This is a code block in LaTeX")

print("Here is some more code")

def whitespace():
    x = 2
    return x
```