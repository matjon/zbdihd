#!/bin/bash

perl ../markdown/Markdown_1.0.1/Markdown.pl --html4tags < Notatki_nowe.md > Notatki_nowe_body.html

cat start.html Notatki_nowe_body.html end.html > Notatki_nowe.html
