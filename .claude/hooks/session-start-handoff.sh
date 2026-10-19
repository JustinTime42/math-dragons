#!/usr/bin/env bash
# SessionStart hook: injects the most recent handoff(s) into a new session's context.
# Stdout from a SessionStart hook is added to Claude's context.
set -euo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
latest="$root/handoffs/LATEST.md"
[[ -f "$latest" ]] || exit 0

echo "## Session handoff context (auto-loaded by .claude/hooks/session-start-handoff.sh)"
echo
echo "The previous session ended with the handoff(s) below. Before acting on related work:"
echo "read the files in its 'Read first' list, check git log since its date for drift, then"
echo "briefly tell Justin where things stand and what the first next action is."
echo
cat "$latest"

# Every 'handoffs/<file>.md' path named in LATEST.md gets printed in full.
grep -oE 'handoffs/[^ )`]+\.md' "$latest" | sort -u | while read -r rel; do
  f="$root/$rel"
  [[ -f "$f" ]] || { echo; echo "(missing: $rel)"; continue; }
  echo
  echo "---"
  echo "### $rel"
  echo
  cat "$f"
done
