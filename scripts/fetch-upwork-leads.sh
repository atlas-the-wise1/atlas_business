#!/bin/bash

###############################################################################
# fetch-upwork-leads.sh
# 
# Fetch Upwork job listings for a given search term via RSS feed.
# Parse titles and URLs, output JSONL format.
# 
# Usage:
#   ./fetch-upwork-leads.sh "AI automation"
#   ./fetch-upwork-leads.sh "data pipeline"
#
# Output: JSONL to stdout (one JSON object per line)
#   {"source":"upwork","title":"...","url":"...","fetched_at":"2026-03-22T...Z"}
#
###############################################################################

set -euo pipefail

# Check for required arguments
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <search-term>" >&2
  exit 1
fi

SEARCH_TERM="$1"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# URL-encode the search term (simple version: replace spaces with +)
ENCODED_TERM=$(echo "$SEARCH_TERM" | sed 's/ /+/g')

# Upwork RSS feed URL
RSS_URL="https://www.upwork.com/ab/feed/jobs/rss?q=${ENCODED_TERM}&sort=recency"

# Fetch RSS feed with timeout (10 seconds max)
RSS_CONTENT=$(curl -s -m 10 "$RSS_URL" 2>/dev/null || echo "")

# Check if fetch succeeded (non-empty content)
if [[ -z "$RSS_CONTENT" ]]; then
  echo "{\"source\":\"upwork\",\"error\":\"fetch_failed\",\"search_term\":\"$SEARCH_TERM\",\"fetched_at\":\"$TIMESTAMP\"}" >&2
  exit 0
fi

# Parse RSS XML: extract <item> blocks, then <title> and <link> within each
# Use grep + sed for compatibility (avoid xmllint dependency)
# This is a basic parser; for production consider xmllint or xq

# Extract item blocks and process
echo "$RSS_CONTENT" | grep -o '<item>.*</item>' | while IFS= read -r item; do
  # Extract title (remove HTML entities if present)
  title=$(echo "$item" | sed -n 's/.*<title>\(.*\)<\/title>.*/\1/p' | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g')
  
  # Extract link
  url=$(echo "$item" | sed -n 's/.*<link>\(.*\)<\/link>.*/\1/p')
  
  # Only output if both title and url are present
  if [[ -n "$title" && -n "$url" ]]; then
    # Escape quotes in title for JSON
    title_escaped=$(echo "$title" | sed 's/"/\\"/g')
    
    # Output JSONL
    cat <<EOF
{"source":"upwork","title":"$title_escaped","url":"$url","fetched_at":"$TIMESTAMP"}
EOF
  fi
done

exit 0
