#!/usr/bin/env bash

# Markdown to LaTeX conversion script    

set -eEu -o pipefail

# Check if pandoc is available
if ! command -v pandoc &> /dev/null
then
    echo "Error: pandoc is not available. Please install pandoc before running this script."
    exit 1
fi

# If no arguments were provided or the --help/-h flag was passed, print usage information
if [[ $# -eq 0 ]] || [[ $1 == "-h" || $1 == "--help" ]]
then
    echo "Usage: $(basename $0) file1.md [file2.md ...]"
    echo "Convert one or more Markdown files to LaTeX using pandoc."
    exit 0
fi

# Retrieve script source directory as DIR. This allows relative pathing to work
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# We run pandoc with the following options. The most important of which are
#  - Use the basic barebones template.tex template
#  - Suppress the auto-generation of LaTeX hyperref targets on sections
#  - Allow raw LaTeX to be passed through from the source markdown file
#  - Write using a custom LaTeX writer (i.e. pandoc conversion ruleset)

# Run the command multiple times, once for each file to build.
for file in "$@"
do
    # Note: we use filename expansion to remove extension on argument via
    #       ${filename%.*}
    # https://stackoverflow.com/a/12152997
    filename=$file

    pandoc \
    "${filename%.*}".md \
    --standalone \
    --wrap=none \
    --columns=80 \
    --biblatex \
    --template="$DIR/template.tex" \
    --from markdown-auto_identifiers+raw_tex+citations \
    --to "$DIR/writer.lua" \
    --filter "$DIR/wordreplace.py"  \
    --filter "$DIR/dropcaps.py" \
    --out "${filename%.*}".tex
done
