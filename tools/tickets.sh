#!/usr/bin/env bash
#
# tickets.sh — command-line workflow for recipe submission tickets.
#
# Usage:
#   tools/tickets.sh list              List open recipe tickets.
#   tools/tickets.sh fetch [N]         Download open ticket N (or every open
#                                      ticket) into _tickets/issue-N/.
#   tools/tickets.sh submit N [-m MSG] Branch, commit, push, and open a PR for
#                                      the prepared files of ticket N.
#
# A ticket is "prepared" when its transcriptions exist as
# _recipes/issue-N-*.md and its photos as images/originals/issue-N-*.jpg
# (the transcription step between fetch and submit is done by a human or AI).
#
# Requires: gh (authenticated), git, curl. Run from the repository root.

set -euo pipefail

REPO="devnu11/recipes"
TICKET_DIR="_tickets"

die() { echo "error: $*" >&2; exit 1; }

require_tools() {
    command -v gh >/dev/null || die "gh is not installed"
    gh auth status >/dev/null 2>&1 || die "gh is not authenticated (run: gh auth login)"
    [ -d .git ] || die "run from the repository root"
}

# Open tickets = issues titled "Recipe:..." or labeled "recipe".
open_ticket_numbers() {
    gh issue list --repo "$REPO" --state open --limit 100 \
        --json number,title,labels \
        --jq '.[] | select((.title | startswith("Recipe")) or ([.labels[].name] | index("recipe"))) | .number'
}

cmd_list() {
    gh issue list --repo "$REPO" --state open --limit 100 \
        --json number,title,author \
        --jq '.[] | "#\(.number)\t\(.title)\t(\(.author.login))"'
}

# Extract GitHub-hosted attachment URLs from an issue body on stdin.
# Only github.com/user-attachments and user-images.githubusercontent.com
# are trusted; any other URL in a ticket is ignored by design.
extract_image_urls() {
    grep -oE 'https://(github\.com/user-attachments/assets|user-images\.githubusercontent\.com)/[A-Za-z0-9/._-]+' || true
}

fetch_one() {
    local n="$1" dir="$TICKET_DIR/issue-$1"
    mkdir -p "$dir"
    gh issue view "$n" --repo "$REPO" --json number,title,body,author,createdAt > "$dir/issue.json"
    gh issue view "$n" --repo "$REPO" --json body --jq .body > "$dir/body.md"

    local i=0 url
    while IFS= read -r url; do
        i=$((i + 1))
        curl -fsSL "$url" -o "$dir/photo-$i.jpg"
        echo "  #$n photo-$i.jpg <- $url"
    done < <(extract_image_urls < "$dir/body.md")
    echo "  #$n fetched ($i photo(s)) -> $dir/"
}

cmd_fetch() {
    local n found=0
    if [ -n "${1:-}" ]; then
        fetch_one "$1"
        return
    fi
    while IFS= read -r n; do
        found=1
        fetch_one "$n"
    done < <(open_ticket_numbers)
    [ "$found" = 1 ] || echo "no open recipe tickets"
}

cmd_submit() {
    local n="${1:-}"; shift || true
    [ -n "$n" ] || die "usage: tools/tickets.sh submit N [-m reviewer-notes]"
    local notes=""
    [ "${1:-}" = "-m" ] && notes="${2:-}"

    local files images branch title
    files=$(ls _recipes/issue-"$n"-*.md 2>/dev/null) || die "no _recipes/issue-$n-*.md found; transcribe first"
    images=$(ls images/originals/issue-"$n"-* 2>/dev/null || true)
    title=$(sed -n 's/^title: //p' $(echo "$files" | head -1))
    branch="add-recipe/issue-$n"

    git checkout -b "$branch" main
    git add $files $images
    git commit -m "Add $title from issue #$n"
    git push -u origin "$branch"
    gh pr create --repo "$REPO" --head "$branch" \
        --title "Add recipe: $title" \
        --body "Transcribed from ticket. Closes #$n. $notes"
    git checkout main
    echo "PR opened for #$n"
}

main() {
    require_tools
    case "${1:-}" in
        list)   cmd_list ;;
        fetch)  shift; cmd_fetch "$@" ;;
        submit) shift; cmd_submit "$@" ;;
        *)      sed -n '2,17p' "$0"; exit 1 ;;
    esac
}

main "$@"
