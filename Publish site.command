#!/bin/bash
# Double click this file in Finder to publish the site.
cd "$(dirname "$0")"
echo "Serviceberry site publisher"
echo
git add -A
if git diff --cached --quiet && [ -z "$(git log origin/main..HEAD 2>/dev/null)" ]; then
  echo "Nothing to publish. Everything is already live."
  echo; read -n 1 -s -r -p "Press any key to close."; exit 0
fi
git status --short
echo
read -r -p "Short note on what changed (or press return): " MSG
[ -z "$MSG" ] && MSG="Update site"
git diff --cached --quiet || git commit -m "$MSG"
if git push; then
  echo
  echo "Published. Live in about a minute at https://serviceberrystrategies.com"
else
  echo
  echo "Push failed. Check your internet connection and GitHub sign in."
fi
echo; read -n 1 -s -r -p "Press any key to close."
