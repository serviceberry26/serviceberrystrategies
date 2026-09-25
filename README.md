# Serviceberry website

One page marketing site for Serviceberry (Serviceberry Strategies LLC), Salt Lake City.
Live at https://serviceberrystrategies.com via GitHub Pages.

## What is here

- `index.html` is the whole site. HTML, CSS, and content in one file. No build step, no dependencies.
- `CNAME` tells GitHub Pages to serve the site at serviceberrystrategies.com.
- `deploy.sh` commits and pushes. Usage: `./deploy.sh "what changed"`

## Still placeholder

The logo icon, the wordmark, the founder portrait, the favicon, and the colours and
typefaces are all stand ins pending the brand guide. Every colour is a CSS custom
property in the `:root` block near the top of `index.html`, so the real palette can be
dropped in by editing that one block.

## How changes get made

Claude edits the files in this folder directly. Eliza then runs:

    ./deploy.sh "what changed"

That commits and pushes, and GitHub Pages rebuilds in about a minute.
