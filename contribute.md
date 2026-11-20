---
layout: default
title: Add a Recipe
permalink: /contribute/
---

# Add a Recipe

Recipes are added by filing a ticket on GitHub. A maintainer (or their AI)
turns the ticket into a pull request that updates this site.

**[File a recipe ticket →](https://github.com/devnu11/recipes/issues/new?template=recipe-submission.yml)**

Attach a photo of the original recipe card if you have one, or paste the
text. That's all that is required — formatting is handled during
processing. If you use an AI assistant, just point it at this page or at
[/llms.txt]({{ '/llms.txt' | relative_url }}).

## Getting a GitHub account

Filing a ticket requires a (free) GitHub account. If you don't have one:

1. Go to [github.com/signup](https://github.com/signup). You need an email
   address, a password, and a username. Verify the email and you're done —
   no payment info, and the free tier is all this site needs.
2. That alone is enough to submit recipes by hand: sign in, click the
   "File a recipe ticket" link above, attach your photo, submit.

To let your AI assistant file tickets for you, give it access in one of
these ways, from simplest to most capable:

- **You do the final click.** The agent prepares the prefilled ticket and
  hands you a link; you sign in, attach the photo, and press Submit. No
  setup, and the agent never touches your account.
- **GitHub CLI** (for agents that run commands on your computer): install
  with `brew install gh`, run `gh auth login`, and approve the browser
  prompt. The agent can then file tickets as you.
- **Access token** (for agents that call the GitHub API): on GitHub go to
  Settings → Developer settings → Personal access tokens → Tokens
  (classic) → Generate new token, check only the `public_repo` scope, set
  an expiration, and give the token to your agent. That scope is enough to
  file issues here.

Never give an agent your GitHub password. A scoped token or a CLI login
can be revoked any time (Settings → Developer settings, or `gh auth
logout`).

## Instructions for AI agents

You are reading the contribution guide for this cookbook. To submit a
recipe on your user's behalf:

1. Submissions are GitHub issues on `devnu11/recipes` — never pull
   requests. Use the "Recipe submission" template (it applies the
   `recipe` label). Title: `Recipe: <name>`.
2. A photo of the original recipe is the most valuable part of a
   submission. If you can authenticate to GitHub, attach it to the issue.
   If you cannot, build this prefilled URL and hand it to your user to
   review, attach the photo, and submit:
   `https://github.com/devnu11/recipes/issues/new?template=recipe-submission.yml&title=Recipe%3A%20<name>`
3. If you include recipe text, transcribe it VERBATIM: keep original
   spelling, abbreviations (Tbs., oleo, 1/2), and quirks. Do not reword,
   normalize units, or add clarifications. Mark unreadable words
   `[illegible]` and uncertain readings `word[?]`.
4. Structure the text as:
   - `Category:` one of Appetizers, Salads & Dressings, Soups, Mains,
     Sides, Breads, Cakes, Cookies & Bars, Desserts, Beverages, Misc
   - `Attribution:` who the recipe came from, if known
   - `## Ingredients` — one bulleted list; an ingredient used in two
     places is a parent bullet (total) with indented sub-bullets for the
     split usages
   - `## Method` — one clear, actionable step per bullet; no run-ons; no
     semicolons (split joined clauses into separate bullets)
5. Machine-readable site data: the full text of every recipe is at
   [/search.json]({{ '/search.json' | relative_url }}); this guide in
   plain text is at [/llms.txt]({{ '/llms.txt' | relative_url }}).
