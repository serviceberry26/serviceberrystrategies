#!/bin/bash
# Double click this file in Finder to publish the site.
cd "$(dirname "$0")"

REPO="serviceberry26/serviceberrystrategies"
API="https://api.github.com/repos/$REPO"

echo "Serviceberry site publisher"
echo

# Reports whether GitHub Pages actually finished building the newest commit.
check_build () {
  local want
  want="$(git rev-parse HEAD)"
  echo "Waiting for GitHub Pages to build..."
  local i
  for i in $(seq 1 30); do
    sleep 6
    local out
    out="$(curl -fsS "$API/actions/runs?per_page=5" 2>/dev/null | python3 -c '
import json,sys
try: runs=json.load(sys.stdin).get("workflow_runs",[])
except Exception: print("unknown"); raise SystemExit
want=sys.argv[1]
for r in runs:
    if r.get("head_sha")==want:
        print(r.get("status"), r.get("conclusion"))
        raise SystemExit
print("none")
' "$want" 2>/dev/null)"
    case "$out" in
      "completed success")
        echo
        echo "Live now at https://serviceberrystrategies.com"
        echo "If your browser still shows the old page, press Command Shift R."
        return 0 ;;
      "completed failure"|"completed cancelled"|"completed timed_out")
        echo
        echo "GitHub received your changes but the site build did not finish."
        echo "Open this page and click Re run jobs on the top entry:"
        echo "https://github.com/$REPO/actions"
        return 1 ;;
      "unknown"|"")
        echo "Could not reach GitHub to check the build. Your changes are pushed."
        return 0 ;;
    esac
    printf "."
  done
  echo
  echo "Still building after three minutes. Check https://github.com/$REPO/actions"
  return 1
}

git add -A
if git diff --cached --quiet && [ -z "$(git log origin/main..HEAD 2>/dev/null)" ]; then
  echo "No new changes to send. Checking whether the last publish actually went live."
  echo
  check_build
  echo; read -n 1 -s -r -p "Press any key to close."; exit 0
fi

git status --short
echo
read -r -p "Short note on what changed (or press return): " MSG
[ -z "$MSG" ] && MSG="Update site"
git diff --cached --quiet || git commit -m "$MSG"

if git push; then
  echo
  check_build
else
  echo
  echo "Push failed. Check your internet connection and GitHub sign in."
fi
echo; read -n 1 -s -r -p "Press any key to close."
