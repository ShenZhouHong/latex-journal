#!/usr/bin/env python3
# This script is a Python pandoc filter that is designed to perform word
# substitutions according to CSV rulesets. These substitutions are currently
# used for ae, oe ligatures, as well as diaeresis. The rulesets are CSV files in
# the format of search,replace. Replacements are meant to be case-sensitive.

import panflute as pf
import string
import csv

# List of word substitution rulesets, in the form of CSV files
ruleset_files: list[str] = [
    './pandoc/ae-ligature.csv',
    './pandoc/oe-ligature.csv',
    './pandoc/diaeresis.csv',
    './pandoc/custom.csv'
]

# Initialise a ruleset dict containing "search":"replace" as key-value pairs
# NB: We use a dictionary instead of a list, because list lookups are in O(n),
# but dictionary lookups by key are in O(1) time.
ruleset: dict[str:str] = {}

# Load and append all rules from rulesets into one master dict
for file in ruleset_files:
    with open(file) as csv_file:
        for row in csv.reader(csv_file, delimiter=','):
            # Append lowercase strings to dict
            ruleset[row[0].lower()] = row[1].lower()

def preserve_case(original: str, substitution:str) -> str:
    """
    Auxiliary function which allows us to preserve case (i.e. capitalization) of
    the original string with the substituted string.
    """
    # First, take care of the trivial cases
    if original.isupper():
        # All uppercase e.g. UPPER
        return substitution.upper()
    elif original.islower():
        # All lowercase e.g. lower
        return substitution.lower()
    elif original[0].isupper and original[1:].islower():
        # Title case    e.g. Title
        return substitution[0].upper() + substitution[1:].lower()
    else:
        # For sPoNgeCaSe Generate the substitution using list comprehension.
        new: list[str] = [
            # Note that we use the modulo of the original's length, so that in
            # cases where len(original) != len(substitution), we do not end up
            # going out of bounds.
            letter.upper() if original[index % (len(original) - 1)].isupper()
            else letter.lower()
            for index, letter in enumerate(substitution)
        ]
        return "".join(new)

def action(element, doc):
    """
    Python pandoc filter which performs case-aware string substitution, with the
    substitutions defined according to CSV rulesets.
    """
    # For every string element
    if isinstance(element, pf.Str):
        # Derive the ruleset key from element.text by normalising it.
        # We do some primitive lemmatizing by removing the plural 's'
        if len(element.text.strip(string.punctuation).lower()) > 0 and element.text.strip(string.punctuation).lower()[-1] == 's':
            key = element.text.strip(string.punctuation).lower()[:-1]
            plural = True
        else:
            key = element.text.strip(string.punctuation).lower()
            plural = False

        # If the word matches a rule in our ruleset
        if key in ruleset:
            # Build case-sensitive replacement and replace text
            replacement = preserve_case(element.text, ruleset[key])

            # If the word is plural, make sure to add the plural 's' back
            if plural:
                replacement += "s"
                
            element.text = replacement

def main(doc=None):
    return pf.run_filter(action, doc=doc)

if __name__ == '__main__':
    main()