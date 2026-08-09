# Framework migration: Octopress → Hugo

**Status: complete and live (2026-08-09).** Executed, pushed, and verified against the live site.
No content changed. The rest of this document is kept as the planning/execution record.

**Note:** this document refers to `master` throughout, since that was the branch name at the time
of planning and execution. `master` was renamed to `main` immediately after (via GitHub's branch
rename, which also updated the default branch and the Pages source config automatically) — read
`master` below as `main` for anything current.

## Scope

Swap the static-site generator from Octopress (Jekyll-based, Ruby) to Hugo. **No content
change** — same post, same page copy, same URLs. This is purely a tooling/framework migration,
not a content or design refresh (unlike the `slashusr.wordpress.com` migration happening in
parallel in the homelab repo's `blog/`, which is a real content migration with hundreds of
comments — this site's situation is much smaller and simpler).

## Current state (as found, 2026-08-09)

- Two-branch Octopress layout: `master` is the compiled HTML output GitHub Pages actually serves
  (this repo is a `<user>.github.io` repo, so it serves directly from `master` root, no `gh-pages`
  branch); `source` (this branch) is the real Octopress project — Ruby-based build via `Rakefile`/
  `Gemfile`, raw Markdown content in `source/_posts/`, Liquid templates in `source/_layouts/` and
  `source/_includes/`, Sass in `.themes/classic/sass/`.
- **Exactly one real blog post**: `source/_posts/2014-01-24-first-post.markdown` ("First Post," a
  short self-deprecating post — no other posts ever followed it).
- **No working comment system** — the theme wires up Disqus (`source/_includes/disqus.html`,
  `post/disqus_thread.html`) but `_config.yml`'s `disqus_short_name:` was never set. Comments were
  never actually functional. Nothing to migrate here, unlike the WordPress blog's real 282
  comments — confirmed by checking the config directly, not assumed.
- Homepage (`source/index.html`) is not custom prose — it's a generated post-listing + sidebar
  template (`{% for post in paginator.posts %}` + sidebar asides), so with only one post, the
  homepage is effectively "the one post plus sidebar widgets," not standalone content to preserve
  separately.
- Site identity, from `_config.yml`: title `Evolve's Github Corner.`, subtitle `A kitchen sink,
  and maybe a blog.`, author `Anupam Sengupta`, `github_user: evolve75`, `twitter_user: evolve75`.
- Permalink structure: `/blog/:year/:month/:day/:title/` — e.g. the one post is at
  `/blog/2014/01/24/first-post/`. Also serves `/atom.xml` (RSS/Atom feed) and `/blog/archives/`
  (a full post-archive listing page).
- **Dead/legacy cruft in the theme config, not content** — flagged for a decision, not silently
  dropped, since "no content change" could be read strictly: `google_analytics_tracking_id:
  UA-326849-8` is a Universal Analytics property ID, and **Google fully sunset Universal Analytics
  in July 2023** — this ID cannot collect data regardless of what platform serves the site, it's
  already non-functional today. Similarly, the theme's Delicious/Pinboard sidebar asides reference
  bookmarking services that no longer meaningfully exist in their 2010s form, and a Google+ sharing
  button references a product Google shut down in 2019. **Recommend dropping all of these** as part
  of the migration — they're broken infrastructure artifacts, not content, and keeping them doesn't
  preserve anything real.

## Recommended approach

**Hugo**, for the same reasons already established for the `slashusr.wordpress.com` migration
(see the homelab repo's `blog/README.md` for the full longevity/community due diligence — Apache
2.0, 13-year track record, ~89k GitHub stars, actively shipping) — no need to re-litigate that
choice for a second, much smaller site.

Given the tiny scope (one post, no comments, a generated homepage), this migration is
substantially simpler than the WordPress one:

- No comment system needed at all (nothing worked before; nothing to replace).
- No bulk content-conversion tooling needed (`wordpress-export-to-markdown` etc.) — one post,
  convert by hand.
- No AWS/CloudFront infrastructure change — this stays exactly where it is, a GitHub Pages
  `<user>.github.io` repo serving `www.anupamsg.me` via the existing `CNAME` file. Framework
  migration only, not a hosting migration.

## Plan

1. **Scaffold a Hugo site** in a new location within this repo (e.g. a `hugo/` working directory
   on this `source` branch, kept separate from the Octopress `source/` tree until the migration is
   validated) — `hugo new site hugo/`.
2. **Recreate the one post** as `hugo/content/blog/first-post.md`, with Hugo `permalinks`
   configured as `blog = "/blog/:year/:month/:day/:title/"` to reproduce the exact existing URL.
   Content is copied verbatim (Markdown → Markdown, minimal reformatting) — this is the one place
   where care matters most given "no content change."
3. **Recreate site identity** in `hugo.toml`: title, subtitle (as a param, since Hugo doesn't have
   a native subtitle field), author, GitHub/Twitter links matching `github_user`/`twitter_user`
   from the old `_config.yml`.
4. **Pick a minimal theme** — given the tiny scope (one post, simple layout), a lightweight Hugo
   theme or even hand-rolled minimal templates both work; no need for anything elaborate. Not
   worth the same design-approximation exercise done for the WordPress blog (PaperMod
   approximating Independent Publisher 2) since this site's original design is a stock 2014
   Octopress "classic" theme, not something distinctive worth preserving pixel-for-pixel.
5. **Recreate `/blog/archives/`** as a Hugo archive/list page over the (single-item) post
   collection — trivial given post count, but the URL should keep working.
6. **Preserve `/atom.xml`** — Hugo supports Atom output natively; configure it to match the
   existing feed path exactly.
7. **Dead-infrastructure items — decided (2026-08-09): drop all of them.** Confirmed by the user.
   The Hugo rewrite carries forward none of: the Google Analytics Universal Analytics tracking ID
   (`UA-326849-8` — non-functional since Google's July 2023 UA sunset regardless of platform), the
   Disqus include/stub (never actually configured with a shortname, never worked), or the
   Delicious/Pinboard/Google+ sidebar widgets (all reference discontinued-in-their-2010s-form
   services). None of these are "content" in the sense the no-content-change constraint protects —
   they're broken theme plumbing from 2014. If analytics is wanted going forward, that's a fresh
   GA4 property as a separate, later decision — not a revival of the dead UA one, and not assumed
   as part of this migration.
8. **Build and diff against the current `master` output** — compare generated URLs, confirm
   `/`, `/blog/2014/01/24/first-post/`, `/blog/archives/`, and `/atom.xml` all resolve with
   equivalent content to what's live today.
9. **Only once verified**, replace `master`'s content with the new Hugo build output — critically,
   **preserve the `CNAME` file exactly** (`www.anupamsg.me`) since that's what makes GitHub Pages
   serve this domain at all; nothing about the DNS/Cloudflare side (documented in the homelab
   repo's `domains/README.md`) needs to change.

## Explicitly not in scope here

- No content changes (per the original instruction) — this is framework-only.
- No hosting change — stays on GitHub Pages, same `www.anupamsg.me` CNAME.
- No comment system addition — there wasn't a working one before; adding Isso/giscus/etc. here
  would be a scope expansion beyond "framework upgrade," not assumed.
- No design refresh beyond what's needed to render cleanly in a minimal Hugo theme.
