---
created: 2025-12-28
tags:
  - type/documentation
  - topic/agents
  - topic/patterns
---

# Two-Agent Pattern

The foundational pattern for long-running autonomous agents.

## Overview

The two-agent pattern addresses a core challenge: agents must work in discrete
sessions, and each new session begins with no memory of what came before.

## The Problem

When agents try to complete complex tasks in a single session:

1. **One-shotting** - Tries to do too much at once
2. **Context exhaustion** - Runs out mid-implementation
3. **Premature completion** - Declares victory too early
4. **Undocumented progress** - Leaves messy state for next session

## The Solution

Split responsibilities between two agent types:

### Initializer Agent (Session 1)

**Purpose:** Set up the foundation for all future work.

**Tasks:**
1. Read application specification (`app_spec.txt`)
2. Create comprehensive feature list (`feature_list.json`)
3. Create environment setup script (`init.sh`)
4. Initialize git repository
5. Create project structure
6. Write initial progress notes (`claude-progress.txt`)

**Key Output:** `feature_list.json` with all features marked as `passes: false`

### Coding Agent (Sessions 2+)

**Purpose:** Make incremental progress on one feature at a time.

**Tasks:**
1. Orient: Read progress files, git logs, feature list
2. Verify: Run sanity check on existing features
3. Choose: Pick highest-priority incomplete feature
4. Implement: Build the feature
5. Test: Verify end-to-end with browser automation
6. Mark: Update `feature_list.json` (only `passes` field)
7. Commit: Save progress with descriptive message
8. Update: Write session notes to `claude-progress.txt`

**Key Principle:** Complete ONE feature perfectly per session.

## Why It Works

| Problem | Solution |
|---------|----------|
| No memory between sessions | Progress files + git history |
| Tries to do too much | One-feature-at-a-time rule |
| Premature completion | Comprehensive feature list upfront |
| Undocumented state | Mandatory commit + progress notes |
| Incomplete testing | Browser automation verification |

## Implementation

```python
# Session 1
if not feature_list_exists:
    prompt = get_initializer_prompt()  # Creates feature list
else:
    prompt = get_coding_prompt()       # Works on features

# Each session gets fresh context
client = create_client(project_dir, model)

async with client:
    await run_agent_session(client, prompt, project_dir)
```

## Session Startup Protocol

Every coding session starts with:

```bash
# 1. Verify location
pwd

# 2. Read progress
cat claude-progress.txt
cat feature_list.json | head -50

# 3. Check git history
git log --oneline -20

# 4. Start environment
./init.sh

# 5. Verify existing features
# (Run 1-2 passing tests to check for regressions)

# 6. Choose next feature
cat feature_list.json | grep '"passes": false' | head -1
```

## Related

- [[3-Resources/claude-agent-sdk/09-long-running-agents-patterns]]
- [[SESSION-MANAGEMENT]]
- [[FEATURE-LIST-SCHEMA]]
