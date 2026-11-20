# Grandma's Cookbook

Family recipes transcribed from the original cards and clippings, published
with GitHub Pages (Jekyll).

## Adding a recipe

Create `_recipes/<slug>.md`:

```markdown
---
title: Apple Pie
category: Desserts
source_page: 42
images:
  - /images/originals/page-042.jpg
---

## Ingredients

- 2 cups flour

## Method

- Mix and bake.
```

Push. The index and search update on the next Pages build.

## Processing submission tickets

```
tools/tickets.sh list        # open recipe tickets
tools/tickets.sh fetch       # download tickets + photos to _tickets/
# transcribe _tickets/issue-N/ into _recipes/issue-N-<slug>.md
# copy photos to images/originals/issue-N-<slug>.jpg
tools/tickets.sh submit N -m "reviewer notes"   # branch + push + PR
```

With Claude Code in this repo, "process the recipe tickets" runs the
whole flow (the transcription step included).

## Layout

- `_recipes/` — one markdown file per recipe
- `images/originals/` — untouched scans of the source pages
- `index.html` — category-grouped index with client-side search
- `tools/ocr.swift` — Apple Vision OCR used to cross-check transcriptions

The source PDF is the record of origin and is deliberately not in this repo.
