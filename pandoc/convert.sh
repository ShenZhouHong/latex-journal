#!/usr/bin/env bash
# Markdown to LaTeX conversion script
pandoc \
test.md \
-s \
--template template.tex \
-f markdown-auto_identifiers \
-t writer.lua \
-o test.tex