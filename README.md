evolve75.github.io
==================

[![Build and deploy](https://github.com/evolve75/evolve75.github.io/actions/workflows/hugo.yml/badge.svg)](https://github.com/evolve75/evolve75.github.io/actions/workflows/hugo.yml)

Source for [evolve75.github.io](http://evolve75.github.io/) / [www.anupamsg.me](https://www.anupamsg.me/).

Built with [Hugo](https://gohugo.io) using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
theme. Single-branch repo — `main` holds only the Hugo source (content, config, theme submodule).
GitHub Actions (`.github/workflows/hugo.yml`) builds and deploys on every push via GitHub Pages'
native Actions integration — no compiled output is ever committed, and there's no second branch to
keep in sync.

Formerly built with Octopress; migrated to Hugo (framework-only, no content change), then
consolidated from a two-branch (`main` + `source`) layout to this single-branch,
Actions-deployed one — see `MIGRATION_PLAN.md` for the record of both changes.

## Building locally

```sh
make serve   # local dev server with drafts, http://localhost:1313
make build   # one-off build into ./public, same flags as CI
```

See `make help` for the full target list (new posts, theme updates, etc.).

## Deploying

Automatic — push to `main` and GitHub Actions builds and deploys. No manual steps.
