#!/bin/bash -e

git push

mv index.html index.html_to_push
git checkout gh-pages

mv index.html_to_push index.html
git commit -a -m 'Updated index.html'
git push
git checkout master
