#!/bin/bash

# generate-social-post.sh
# Generate ready-to-post social media content from templates
# Usage: ./generate-social-post.sh <pillar>
# Pillars: automation, pipeline, research, productivity

set -euo pipefail

PILLAR="${1:?Error: Please provide a content pillar (automation|pipeline|research|productivity)}"

# Validate pillar
case "$PILLAR" in
  automation|pipeline|research|productivity)
    ;;
  *)
    echo "Error: Invalid pillar '$PILLAR'. Must be one of: automation, pipeline, research, productivity"
    exit 1
    ;;
esac

# Templates array (will randomly select one)
declare -a TEMPLATES

# Template 1: Case Study
TEMPLATES[0]="case_study"

# Template 2: Problem-Solution
TEMPLATES[1]="problem_solution"

# Template 3: System Building
TEMPLATES[2]="system_building"

# Template 4: Economic Wake-Up Call
TEMPLATES[3]="economic"

# Template 5: Threaded Deep Dive
TEMPLATES[4]="threaded"

# Select random template
RANDOM_IDX=$((RANDOM % ${#TEMPLATES[@]}))
SELECTED_TEMPLATE="${TEMPLATES[$RANDOM_IDX]}"

# Generate post based on pillar and template
case "$PILLAR:$SELECTED_TEMPLATE" in
  automation:case_study)
    cat << 'EOF'
Here's how I automated vendor compliance checks in 15 minutes using AI agents: we went from 8 hours/week of manual document review to 5 minutes of automated processing.

What used to be tedious spreadsheet matching is now a daily agent task.

Concrete result: caught 12 compliance violations that would've been missed
Tools used: Claude API + agent framework
The key insight: agents are perfect for pattern-matching across documents

Would your team benefit from this level of automation?
EOF
    ;;
  automation:problem_solution)
    cat << 'EOF'
Most people do weekly compliance audits manually. Here's the automated version:

Before: 8 hours/week of spreadsheet work, high error rate, delayed detection
After: 5 minutes, 100% accuracy, real-time alerts

The automation: Deploy an AI agent that ingests compliance docs, matches against requirements, flags exceptions, sends alerts
Cost: <$100/month
Result: 99% time savings + zero false negatives

How many teams could reclaim those 8 hours?
EOF
    ;;
  automation:system_building)
    cat << 'EOF'
I built a system that audits vendor compliance every day without me touching it. Here's how:

Context: We track 50+ vendors against regulatory requirements. Manual process was breaking us.

The architecture:
1. Daily agent kicks off, ingests latest compliance docs from shared drive
2. Cross-references against our compliance matrix
3. Flags exceptions → creates tickets → sends Slack alert

Time investment: 4 hours to build
Time saved per cycle: 8 hours/week
Payback period: 2 weeks

What repetitive audit process could you delegate to an agent today?
EOF
    ;;
  automation:economic)
    cat << 'EOF'
The $250K mistake in operations that AI can fix for free:

Setup: Most teams spend 50+ hours/week on manual task automation—document matching, approval workflows, compliance checks.

The math:
- 50 hours/week × 50 weeks × $50/hour (blended cost) = $125K
- Add: Error costs, rework, compliance violations = +$125K
- Total annual cost: $250K+

The fix: Deploy AI agents to handle matching, flagging, and triage (2 hours to set up, <$100/month)
Cost to implement: <$500 (setup time)
Payback: 1 week

Most orgs have 3-5 of these hiding in plain sight.
EOF
    ;;
  automation:threaded)
    cat << 'EOF'
Thread: How to build an autonomous customer research bot with AI agents (no coding required):

1/ Start with the problem. Your sales team spends 5 hours/week finding, contacting, and summarizing customer feedback. It's repetitive. It's breakable.

2/ The traditional approach: hire another analyst, train them, manage them, hope they stay. Cost: $80K+/year.

3/ The agent way: Deploy a system that automatically:
   - Finds relevant customers (from CRM)
   - Composes personalized outreach
   - Collects feedback
   - Summarizes themes
   - Alerts sales to outliers

4/ Concretely:
   Step 1: Define customer segment + questions (5 min)
   Step 2: Connect CRM + email via agent (15 min)
   Step 3: Deploy daily run + Slack alerts (10 min)
   Step 4: Review responses weekly (30 min)

5/ The payoff: Your team goes from reactive ("let me find feedback") to proactive ("here's what customers said this week")

6/ You can build this in 30 minutes. No Python required. Just prompts.

Who's going to try this on their customer research process?
EOF
    ;;

  pipeline:case_study)
    cat << 'EOF'
Here's how I automated data validation across 3 sources in 20 minutes using AI agents: caught 47 bad records that would've corrupted our warehouse.

We built a daily agent that validates schema, checks for duplicates, and flags anomalies.

Concrete result: zero corrupted pipeline incidents this quarter (previously: 2-3/month)
Tools used: dbt + agent validation layer
The key insight: agents excel at fuzzy matching and exception handling that static tests can't catch

How much time is bad data costing your team right now?
EOF
    ;;
  pipeline:problem_solution)
    cat << 'EOF'
Most people do data validation manually. Here's the automated version:

Before: 2 hours/week manual checking, miss 5-10% of issues, incidents in production
After: 5 minutes, real-time validation, zero incidents

The automation: AI agent validates schema, checks data quality rules, matches against historical patterns, alerts on anomalies
Cost: <$50/month
Result: 95% reduction in data incidents, zero false negatives

What's the true cost of your undetected bad data?
EOF
    ;;
  pipeline:system_building)
    cat << 'EOF'
I built a system that validates data integrity every 6 hours without me touching it. Here's how:

Context: We ingest from 10 sources. Schema changes, bad data, missing values. Manual checks weren't catching 10% of issues.

The architecture:
1. Agent runs every 6 hours, ingests latest batches
2. Validates against schema + historical patterns
3. Flags anomalies → creates PagerDuty incident → Slack alert
4. Detailed report of what failed + why

Time investment: 6 hours to build
Time saved per cycle: 2 hours/week
Payback period: 3 weeks

What data quality problem could you delegate to an agent?
EOF
    ;;
  pipeline:economic)
    cat << 'EOF'
The $180K mistake in data teams that AI can fix:

Setup: Data QA is tedious—manual validation of schemas, duplicates, nulls, outliers. Most teams spend 100+ hours/month on this.

The math:
- 100 hours/month × 12 × $40/hour (data engineer) = $48K
- Add: Cost of incidents from missed bad data = $80K+
- Add: Rework from corrupted pipelines = $50K+
- Total: $180K+/year

The fix: AI agent validation 24/7 (<$100/month, 1 day to build)
Cost to implement: $500 (one-time setup)
Payback: 2 weeks

Your data quality problem has a price tag attached.
EOF
    ;;
  pipeline:threaded)
    cat << 'EOF'
Thread: How to build a data quality guardian that runs 24/7 (no coding required):

1/ Your data pipelines are breaking silently. You don't know until someone in marketing says "why are these numbers wrong?"

2/ The traditional fix: hire a data reliability engineer. Cost: $150K+/year.

3/ The agent way: Deploy a system that:
   - Monitors 10 data sources in real-time
   - Detects schema drift, duplicates, nulls
   - Validates against historical patterns
   - Alerts on anomalies before they reach production

4/ Concretely:
   Step 1: Define your data quality rules (15 min)
   Step 2: Connect agent to your data warehouse (10 min)
   Step 3: Set up alerting to Slack/PagerDuty (5 min)
   Step 4: Review daily summary (5 min)

5/ The payoff: Zero silent failures. Your pipelines are trustworthy again.

6/ You can build this in 30 minutes. No dbt required. Just logic.

What's one data source you'd put under 24/7 surveillance?
EOF
    ;;

  research:case_study)
    cat << 'EOF'
Here's how I automated competitor news ingestion in 10 minutes (daily) using AI agents: now I know about competitors' launches before they announce.

We built a daily agent that scrapes 20 sources, ranks by importance, and synthesizes into an exec summary.

Concrete result: caught 3 competitive moves 48 hours before announcement
Tools used: Claude API + web scraping
The key insight: agents are perfect for pattern-detection across noisy data

How much competitive signal are you missing right now?
EOF
    ;;
  research:problem_solution)
    cat << 'EOF'
Most people monitor industry newsletters manually. Here's the automated version:

Before: read 20 newsletters/week, miss patterns, spend 5 hours, still flying blind
After: 10 minutes, zero context-switching, always know what competitors are doing

The automation: AI agent ingests 20+ industry sources, extracts competitive moves, ranks by impact, delivers daily digest
Cost: <$75/month
Result: Perfect visibility into competitive landscape

What industry signals are you missing because you're reading manually?
EOF
    ;;
  research:system_building)
    cat << 'EOF'
I built a system that scans the market for competitive threats every day without me touching it. Here's how:

Context: We compete with 15 companies. Manual tracking across product updates, job postings, funding news was impossible.

The architecture:
1. Agent runs daily, ingests from: product RSS, job boards, Crunchbase, social media
2. Extracts competitive moves + rates by threat level
3. Synthesizes weekly exec brief + Slack alert
4. Tracks: feature launches, hiring patterns, funding, market repositioning

Time investment: 8 hours to build and tune
Time saved per cycle: 5 hours/week
Payback period: 2 weeks

What blind spot could you close with competitive automation?
EOF
    ;;
  research:economic)
    cat << 'EOF'
The $400K mistake in strategy teams that AI can fix:

Setup: Competitive intelligence is done manually by overqualified people reading newsletters. This is a misallocation of $150K+ salary.

The math:
- 10 hours/week × 50 weeks × $150/hour (strategist) = $75K
- Add: Missed competitive threats that cost market share = $200K+
- Add: Slower product decisions because intel is delayed = $125K+
- Total: $400K+/year

The fix: AI agent competitive monitoring 24/7 (<$100/month)
Cost to implement: $800 (one-time setup)
Payback: 5 days

Your strategy team is wasting time on manual work.
EOF
    ;;
  research:threaded)
    cat << 'EOF'
Thread: How to build a market-scanning system with AI agents (no coding required):

1/ You're making product decisions with 1-week-old information. Your competitors shipped 3 things you didn't know about.

2/ The traditional fix: hire a market researcher. Cost: $120K+/year for incomplete coverage.

3/ The agent way: Deploy a system that:
   - Ingests 100+ market signals (news, job postings, funding, product updates)
   - Scores by relevance and threat level
   - Delivers daily digest + weekly synthesis
   - Alerts when something big breaks

4/ Concretely:
   Step 1: Define what "big" means for your industry (10 min)
   Step 2: Connect agent to 10+ signal sources (20 min)
   Step 3: Set up daily Slack digest (5 min)
   Step 4: Review and act (30 min/week)

5/ The payoff: Real-time market awareness. No more surprises.

6/ You can build this in 35 minutes. No data science required.

What market would you monitor if you had perfect visibility?
EOF
    ;;

  productivity:case_study)
    cat << 'EOF'
Here's how I automated meeting scheduling in 5 minutes using AI agents: our sales team now spends 10x more time on qualified prospects instead of calendar Tetris.

We built an agent that finds common slots, sends invites, handles cancellations, reschedules conflicts.

Concrete result: 40+ meeting hours reclaimed per month
Tools used: Claude API + calendar integration
The key insight: agents handle coordination better than humans do

How many hours is your team wasting on logistics instead of strategy?
EOF
    ;;
  productivity:problem_solution)
    cat << 'EOF'
Most people do meeting scheduling manually. Here's the automated version:

Before: 5 emails per appointment, 30 min/week lost to coordination, frequent reschedules
After: zero emails, 5 min/week, automatic conflict resolution

The automation: AI agent finds available slots, proposes times, sends calendar invites, handles cancellations and rescheduling
Cost: <$50/month
Result: 40+ hours/month reclaimed for real work

What would your team do with 40 hours of reclaimed time?
EOF
    ;;
  productivity:system_building)
    cat << 'EOF'
I built a system that manages my calendar autonomously. No more email back-and-forth. Here's how:

Context: As an ops person, I was spending 5+ hours/week on meeting coordination across 3 timezones. It was killing focus.

The architecture:
1. Agent receives meeting request from Slack
2. Checks my calendar + attendees' availability
3. Proposes 3 time options + timezone context
4. Books confirmed slot + sends calendar invites
5. Monitors for conflicts, auto-reschedules, notifies team

Time investment: 3 hours to build
Time saved per cycle: 5 hours/week
Payback period: 1 week

What coordination burden could you offload to an agent today?
EOF
    ;;
  productivity:economic)
    cat << 'EOF'
The $120K mistake in ops that AI can fix for free:

Setup: Meeting scheduling, email triage, task prioritization—these are invisible time sinks. A 5-person team spends 10+ hours/week on coordination logistics.

The math:
- 50 hours/week × 50 weeks × $50/hour = $125K
- Add: Context-switching cost (lost focus, rework) = not quantified but massive
- Total: $120K+/year in pure coordination waste

The fix: AI agents handle all routing and scheduling (<$100/month)
Cost to implement: $400 (setup)
Payback: 3 weeks

Your team is drowning in logistics, not because work is hard, but because coordination is broken.
EOF
    ;;
  productivity:threaded)
    cat << 'EOF'
Thread: How to build an autonomous meeting scheduler with AI agents (no coding required):

1/ You just got back from a vacation. Your inbox has 47 meeting requests. It'll take you 2 hours to schedule them.

2/ The traditional way: hire an executive assistant. Cost: $60K+/year.

3/ The agent way: Deploy a system that:
   - Receives meeting requests (via email, Slack, form)
   - Checks your calendar + other attendees' availability
   - Proposes times
   - Sends calendar invites
   - Handles cancellations and rescheduling

4/ Concretely:
   Step 1: Set availability rules (10 min)
   Step 2: Connect agent to your calendar (5 min)
   Step 3: Set up email/Slack trigger (5 min)
   Step 4: Done. Meetings now schedule themselves.

5/ The payoff: You go from reactive scheduling to automatic orchestration.

6/ You can build this in 20 minutes. No coding required.

How many hours/month would you get back?
EOF
    ;;

  *)
    # Should not reach here due to earlier validation
    echo "Error: Unknown pillar/template combination"
    exit 1
    ;;
esac

echo ""
echo "---"
echo "Generated post (pillar: $PILLAR, template: $SELECTED_TEMPLATE)"
echo "---"
