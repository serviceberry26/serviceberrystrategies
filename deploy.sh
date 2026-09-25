#!/bin/bash
# Publish the current folder to GitHub. Live in about a minute.
# Usage:  ./deploy.sh "what changed"
set -e
cd "$(dirname "$0")"
git add -A
if git diff --cached --quiet; then
  echo "No changes to publish."
  exit 0
fi
git commit -m "${1:-Update site}"
git push
echo
echo "Pushed. Live in about a minute:"
echo "  https://serviceberrystrategies.com"
