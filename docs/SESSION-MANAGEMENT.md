---
created: 2025-12-28
tags:
  - type/documentation
  - topic/agents
  - topic/sessions
---

# Session Management

How agents bridge context across multiple sessions.

## The Challenge

Each agent session starts with a fresh context window. The agent has no memory
of previous work. We need artifacts that enable the next agent to quickly
understand:

1. What has been built
2. What is currently working
3. What needs to be done next

## Session Artifacts

### feature_list.json

The source of truth for all features.

**Created by:** Initializer agent (Session 1)
**Modified by:** Coding agents (change `passes` field only)

```json
[
  {
    "category": "functional",
    "description": "User can create a new task",
    "steps": [
      "Click 'New Task' button",
      "Fill in form fields",
      "Click 'Save'",
      "Verify task appears in list"
    ],
    "passes": true
  }
]
```

**Rules:**
- Never remove features
- Never edit descriptions or steps
- Only change `passes: false` to `passes: true`
- Only after thorough testing

### claude-progress.txt

Session notes and handoff information.

**Format:**

```
=== SESSION 1 (2025-12-28 09:00) ===
Type: Initializer
- Created feature_list.json with 50 features
- Initialized git repository
- Created init.sh startup script

=== SESSION 2 (2025-12-28 10:30) ===
Type: Coding
- Implemented: Feature #1 - User login
- Tested: End-to-end with Puppeteer
- Status: Passing
- Next: Feature #2 - User registration
```

### init.sh

Environment setup script.

**Purpose:**
- Install dependencies
- Start development servers
- Print access URLs

```bash
#!/bin/bash
npm install
npm run dev &
echo "App running at http://localhost:3000"
```

### Git History

Code changes with descriptive commits.

```
abc1234 Implement user login - verified end-to-end
def5678 Add task creation form - tested with Puppeteer
ghi9012 Fix responsive layout on mobile
```

## Session Lifecycle

### Session Start

1. Read `claude-progress.txt` for context
2. Read `feature_list.json` for work status
3. Check `git log` for recent changes
4. Run `init.sh` to start environment
5. Verify existing features still work

### During Session

1. Work on ONE feature
2. Test thoroughly
3. Commit progress frequently
4. Update progress notes

### Session End

1. Ensure all changes committed
2. Update `claude-progress.txt`
3. Update `feature_list.json` if tests passed
4. Leave app in working state
5. No broken features

## Progress Tracking

```python
def print_progress_summary(project_dir):
    passing, total = count_passing_tests(project_dir)
    percentage = (passing / total) * 100
    print(f"Progress: {passing}/{total} ({percentage:.1f}%)")
```

## Auto-Continue

Sessions auto-continue after a brief delay:

```python
if status == "continue":
    print(f"Auto-continuing in {delay}s...")
    await asyncio.sleep(delay)
    # Start next session with fresh context
```

## Related

- [[TWO-AGENT-PATTERN]]
- [[FEATURE-LIST-SCHEMA]]
- [[3-Resources/claude-agent-sdk/04-sessions]]
