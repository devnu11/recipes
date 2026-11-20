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
text. That's all that is required — formatting is handled during processing.

## For AI assistants

If you are an AI assistant submitting a recipe on someone's behalf, copy the
prompt below. It contains everything needed to file a well-formed ticket.

```text
Submit a recipe to the cookbook at github.com/devnu11/recipes:

1. Open a GitHub issue on devnu11/recipes using the "Recipe submission"
   template (it applies the `recipe` label). Title: "Recipe: <recipe name>".

2. Attach a photo of the original recipe (drag into the issue body), or
   include its full text. Photos of the original are preferred — the site
   displays them alongside the transcription.

3. If you include text, transcribe VERBATIM: keep original spelling,
   abbreviations (Tbs., oleo, 1/2), and quirks. Do not reword, normalize
   units, or add clarifications. Then structure it exactly like this:

   Category: <one of: Appetizers, Salads & Dressings, Soups, Mains, Sides,
   Breads, Cakes, Cookies & Bars, Desserts, Beverages, Misc>

   Attribution: <who the recipe came from, if known>

   ## Ingredients

   - 1 cup flour
   - 1 cup sugar
       - 3/4 cup for filling
       - 1/4 cup for topping

   ## Method

   - One clear, actionable step per bullet.
   - Split semicolon-joined clauses into separate bullets.

   Rules: ingredients are a bulleted list; an ingredient used in two places
   is a parent bullet (total) with its split usages as indented sub-bullets.
   Method steps are bullets, no run-ons, no semicolons. Mark unreadable
   words [illegible] and uncertain readings with [?].

4. Do not open a pull request. The ticket is the submission; maintainers
   generate the PR.
```
