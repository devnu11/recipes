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
