#!/bin/bash

# B2B Lead Scoring Script
# Usage: ./score-b2b-lead.sh "Company Name" "company description or posting content"
# Output: JSON object with company, fit_score, and reason

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <company_name> <description_or_content>" >&2
    exit 1
fi

COMPANY="$1"
DESCRIPTION="$2"

# Initialize score and reason array
SCORE=0
REASON_PARTS=()

# Lowercase copy for case-insensitive matching
DESCRIPTION_LOWER=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]')

# Check for industry keywords (+1 each, max +5)
if echo "$DESCRIPTION_LOWER" | grep -qi "finance\|hedge\|fund\|investment\|trading\|portfolio"; then
    SCORE=$((SCORE + 1))
    REASON_PARTS+=("Finance (+1)")
fi

if echo "$DESCRIPTION_LOWER" | grep -qi "marketing\|advertising\|agency\|content\|creative\|campaign"; then
    SCORE=$((SCORE + 1))
    REASON_PARTS+=("Marketing (+1)")
fi

if echo "$DESCRIPTION_LOWER" | grep -qi "consulting\|consultant\|strategy\|advisory\|business\|intelligence"; then
    SCORE=$((SCORE + 1))
    REASON_PARTS+=("Consulting (+1)")
fi

if echo "$DESCRIPTION_LOWER" | grep -qi "e-commerce\|ecommerce\|retail\|store\|marketplace\|seller\|inventory\|pricing"; then
    SCORE=$((SCORE + 1))
    REASON_PARTS+=("E-commerce (+1)")
fi

if echo "$DESCRIPTION_LOWER" | grep -qi "saas\|software\|platform\|app\|technology\|tech\|startup"; then
    SCORE=$((SCORE + 1))
    REASON_PARTS+=("SaaS (+1)")
fi

# Check for company size signals (+2 for sweet spot 5-200)
# Look for number patterns or size descriptors
if echo "$DESCRIPTION_LOWER" | grep -qEi "[0-9]{1,3}\s*(employee|person|team member|staff|headcount)"; then
    # Try to extract numbers and validate range
    NUMBERS=$(echo "$DESCRIPTION" | grep -oEi "[0-9]{1,3}" | head -1)
    if [ -n "$NUMBERS" ]; then
        if [ "$NUMBERS" -ge 5 ] && [ "$NUMBERS" -le 200 ]; then
            SCORE=$((SCORE + 2))
            REASON_PARTS+=("Company size $NUMBERS (5-200 range, +2)")
        fi
    fi
elif echo "$DESCRIPTION_LOWER" | grep -qEi "small|lean|growing|scaling|series.*seed|series.*a|series.*b|startup|bootstrap"; then
    # Implied small company
    SCORE=$((SCORE + 2))
    REASON_PARTS+=("Implied small/growing company (+2)")
fi

# Check for recent pain signals (+2 each, max +2 for this category)
PAIN_SIGNAL_BONUS=0

if echo "$DESCRIPTION_LOWER" | grep -qEi "spending.*time|too.*much.*time|manual.*process|time.*consuming|tedious"; then
    if [ "$PAIN_SIGNAL_BONUS" -eq 0 ]; then
        PAIN_SIGNAL_BONUS=2
        REASON_PARTS+=("Pain signal: time/process overhead (+2)")
    fi
fi

if echo "$DESCRIPTION_LOWER" | grep -qEi "need.*automate|automat|need.*tool|lack.*tool|missing.*infrastructure|data.*gap"; then
    if [ "$PAIN_SIGNAL_BONUS" -eq 0 ]; then
        PAIN_SIGNAL_BONUS=2
        REASON_PARTS+=("Pain signal: automation/tool need (+2)")
    fi
fi

if echo "$DESCRIPTION_LOWER" | grep -qEi "research|monitoring|tracking|signal|intel|competit"; then
    if [ "$PAIN_SIGNAL_BONUS" -eq 0 ]; then
        PAIN_SIGNAL_BONUS=2
        REASON_PARTS+=("Pain signal: research/intelligence focus (+2)")
    fi
fi

if echo "$DESCRIPTION_LOWER" | grep -qEi "analyst|analytics|data.*team|no.*data"; then
    if [ "$PAIN_SIGNAL_BONUS" -eq 0 ]; then
        PAIN_SIGNAL_BONUS=2
        REASON_PARTS+=("Pain signal: data/analytics need (+2)")
    fi
fi

SCORE=$((SCORE + PAIN_SIGNAL_BONUS))

# Cap score at 5
if [ "$SCORE" -gt 5 ]; then
    SCORE=5
fi

# Build reason string
REASON=$(IFS=', '; echo "${REASON_PARTS[*]}")
if [ -z "$REASON" ]; then
    REASON="No strong fit signals detected"
fi

# Output as JSON
cat <<EOF
{"company":"$COMPANY","fit_score":$SCORE,"reason":"$REASON"}
EOF
