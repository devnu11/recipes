# Grandma's Cookbook — Site Plan & Build Prompt

## Source of record

`Grandma's cookbook original with ocr.pdf` — 121 pages, scanned images, no usable
text layer. **Never modified.** All transcription is done by reading the page
images directly.

## Architecture

Jekyll site on GitHub Pages (native support, no CI config).

```
/_config.yml                  # collection config for _recipes
/_recipes/<slug>.md           # one file per recipe
/_layouts/recipe.html         # recipe page template
/images/originals/page-NNN.jpg# lossless extraction via pdfimages
/index.html                   # category-grouped A-Z index + search box
/search.json                  # Liquid-generated index: title, ingredients, url
/assets/search.js             # client-side filter over search.json
```

- Search: client-side JS over `search.json` (titles + ingredients).
- Adding a recipe: drop a new `.md` into `_recipes/`, push. Index and search
  update on next Pages build.

## Recipe file format

```markdown
---
title: Apple Pie
category: Desserts
source_page: 42
image: /images/originals/page-042.jpg
---

## Ingredients

- 2 cups flour
- 1 cup sugar
    - 3/4 cup for filling
    - 1/4 cup for topping

## Method

- Cream butter and sugar.
- Add eggs one at a time.
```

Recipe page displays transcription with a link/embed of the original scan.

## Transcription pipeline

- Vision-based: subagents transcribe chunks of ~10-15 pages each by reading
  the page images, writing `_recipes/*.md` directly.
- Tesseract rejected: tested, adequate on typed pages but lossy (fractions,
  lb/1b) and useless on cursive, which is roughly half the book.
- Git: local repo, commit after image extraction and after each chunk.
  Pushing to GitHub is handled by the user.
- The source PDF stays out of the repo (98.6 MB, near GitHub's 100 MB limit).
  Only extracted page images are committed.

## Transcription rules

1. **Verbatim wording.** Keep original spelling, abbreviations (Tbs., oleo),
   and quirks. No content editing in the first pass.
2. **Ingredients:** bulleted list. If one ingredient is used in two places,
   show total as parent bullet with usage split as sub-bullets.
3. **Method:** bulleted. Convert sentences to bullets. Split semicolons into
   separate bullets. One clear, actionable step per bullet. No run-ons.
4. **Only structural changes** (sentence → bullet, semicolon → split). No
   rewording, no unit normalization, no clarifications.
5. Illegible text marked `[illegible]`; uncertain readings marked `[?]`.
   Both logged in `TRANSCRIPTION_NOTES.md` with page numbers for review.

## Page-to-recipe mapping

- Default: one page = one recipe.
- A page with multiple recipes → multiple `.md` files, same `source_page`.
- A recipe spanning pages → one `.md`, `source_page` lists all pages, all
  images linked.
- Non-recipe pages (covers, blanks, notes) logged in `TRANSCRIPTION_NOTES.md`
  and skipped.

## Index

Grouped by category (inferred during transcription, editable in front matter),
alphabetical within category. Search box filters across all categories.

## Phases

1. **Phase 1 (this build):** extract images, transcribe all 121 pages, build
   Jekyll site, verify locally, ready to push to GitHub.
2. **Phase 2 (later):** image cleanup — crop, deskew, white-balance the
   originals.

## Verification

- Apple Vision cross-check: `tools/ocr.swift` (run by user on macOS) OCRs each
  page image to `ocr-text/page-NNN.txt` via VNRecognizeTextRequest. Claude
  diffs against transcriptions (normalized for whitespace/punctuation/bullet
  restructuring) and writes `REVIEW.md` listing only content disagreements,
  with both readings and the source image. User reviews flagged items only.
- Spot-check N random pages: transcription vs. image.
- Jekyll build passes; all recipe pages render; every image referenced exists.
- Search returns expected hits for sampled ingredients.
