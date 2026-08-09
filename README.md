evolve75.github.io
==================

Source for [evolve75.github.io](http://evolve75.github.io/) / [www.anupamsg.me](https://www.anupamsg.me/).

Built with [Hugo](https://gohugo.io) using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
theme — the Hugo project (content, config, theme submodule) lives under `hugo/` on this branch.

Formerly built with Octopress; migrated to Hugo (framework-only, no content change) — see
`MIGRATION_PLAN.md` for the record of that migration.

## Building

```sh
cd hugo
git submodule update --init
hugo --minify
```

## Deploying

The `main` branch holds the compiled site output that GitHub Pages serves directly (this is a
`<user>.github.io` repo, so it serves from `main` root, no `gh-pages` branch). To publish:

```sh
cd hugo && hugo --minify
cd ..
# copy hugo/public/* into the main branch's root, preserving CNAME
```
