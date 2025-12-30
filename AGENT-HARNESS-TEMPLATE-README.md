---
created: 2025-12-28
tags:
  - type/project
  - topic/agents
  - topic/automation
  - topic/claude-sdk
status: active
priority: p1
description: Reusable template for building long-running autonomous agents
---

# Agent Harness Template

A reusable template for building long-running autonomous agents using the Claude Agent SDK, implementing Anthropic's two-agent pattern.

[[3-Resources/anchors/status-active]]
[[3-Resources/anchors/priority-p1]]

---

## Quick Start

```bash
# 1. Install Claude Code SDK
pip install claude-code-sdk

# 2. Copy template to your project
cp -r template/ /path/to/your/project/

# 3. Edit the application specification
vim /path/to/your/project/prompts/app_spec.txt

# 4. Authenticate (choose ONE option)
#    Option A: Claude Pro/Max subscription (recommended)
claude login

#    Option B: API key (pay-as-you-go)
export ANTHROPIC_API_KEY='sk-ant-...'

# 5. Run the agent
python /path/to/your/project/autonomous_agent.py --project-dir ./my-project
```

**Authentication:** Supports both `claude login` (subscription) AND `ANTHROPIC_API_KEY` (API). Package `claude-code-sdk` imports as `claude_code_sdk`.

---

## Architecture

### Two-Agent Pattern

Based on Anthropic's ["Effective harnesses for long-running agents"](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents):

| Agent | Session | Purpose |
|-------|---------|---------|
| **Initializer** | Session 1 | Sets up environment, creates feature list, initializes git |
| **Coding** | Sessions 2+ | Implements one feature at a time, tests, commits |

### Progress Tracking

| File | Purpose |
|------|---------|
| `feature_list.json` | Source of truth for all features (only modify `passes` field) |
| `claude-progress.txt` | Session notes and handoff information |
| `init.sh` | Environment setup script |
| Git history | Code changes and commit messages |

---

## Template Structure

```
template/
├── autonomous_agent.py      # Main entry point
├── agents/
│   ├── __init__.py          # Agent session logic
│   └── client.py            # SDK client configuration
├── prompts/
│   ├── app_spec.txt         # Application specification (EDIT THIS)
│   ├── initializer_prompt.md
│   └── coding_prompt.md
├── utils/
│   ├── __init__.py
│   ├── security.py          # Command allowlist (30 commands)
│   ├── progress.py          # Progress tracking
│   ├── prompts.py           # Prompt loading utilities
│   └── test_security.py     # Security tests (99 tests)
├── config/
│   ├── settings.json        # Security settings
│   └── mcp_servers.json     # MCP server configs
├── requirements.txt
├── .gitignore
└── README.md
```

---

## Usage

### Command Line Options

```bash
python autonomous_agent.py --help

Options:
  --project-dir PATH    Project directory (default: ./autonomous_demo_project)
  --max-iterations N    Maximum iterations (default: unlimited)
  --model MODEL         Claude model (default: claude-sonnet-4-5-20250929)
  --feature-count N     Target features to generate (default: 50)
```

### Examples

```bash
# Fresh start
python autonomous_agent.py --project-dir ./my-app

# Continue existing project
python autonomous_agent.py --project-dir ./my-app

# Limit iterations for testing
python autonomous_agent.py --project-dir ./my-app --max-iterations 5
```

---

## Customization

### 1. Edit Application Specification

The `prompts/app_spec.txt` file defines what the agent builds:

```text
# My Application Specification

## Overview
[Describe your application]

## Technology Stack
- Frontend: [React, Vue, etc.]
- Backend: [Node.js, Python, etc.]
- Database: [PostgreSQL, MongoDB, etc.]

## Features
1. [Feature 1]
2. [Feature 2]
...
```

### 2. Modify Command Allowlist

Edit `utils/security.py` to allow/block specific bash commands:

```python
ALLOWED_COMMANDS = {
    "ls", "cat", "head", "tail",    # File inspection
    "npm", "node", "npx",            # Node.js
    "python", "python3", "pip",      # Python
    "git",                           # Version control
    ...
}
```

### 3. Configure MCP Servers

Edit `config/mcp_servers.json` for additional tools:

```json
{
  "puppeteer": {
    "command": "npx",
    "args": ["puppeteer-mcp-server"]
  },
  "database": {
    "command": "python",
    "args": ["-m", "mcp_server_database"]
  }
}
```

---

## How It Works

### Session Startup Protocol

Each coding session:

1. **pwd** - Verify working directory
2. **Read progress files** - Get session history
3. **Read feature_list.json** - Find next feature
4. **git log** - See recent commits
5. **Run init.sh** - Start development server
6. **Basic sanity check** - Verify app works
7. **Implement ONE feature**
8. **Test end-to-end**
9. **Mark as passing**
10. **Commit and update progress**

### Feature List Schema

```json
[
  {
    "category": "functional",
    "description": "User can log in with email",
    "steps": [
      "Navigate to login page",
      "Enter credentials",
      "Verify redirect to dashboard"
    ],
    "passes": false
  }
]
```

---

## Security Model

Three layers of defense:

1. **OS-level Sandbox** - Isolated bash execution
2. **Filesystem Restrictions** - Project directory only
3. **Command Allowlist** - Only permitted commands

---

## Related Resources

- [[3-Resources/claude-agent-sdk/MASTER-AGENT-SDK-REFERENCE]] - SDK documentation
- [[3-Resources/claude-agent-sdk/09-long-running-agents-patterns]] - Best practices
- [Claude Quickstarts](https://github.com/anthropics/claude-quickstarts) - Source repo

---

## Files

| File | Description |
|------|-------------|
| [[tasks]] | Current implementation tasks |
| [[template/autonomous_agent.py]] | Main entry point |
| [[template/prompts/app_spec.txt]] | Application specification |
| [[docs/TWO-AGENT-PATTERN]] | Pattern documentation |

---

*Based on: https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding*
