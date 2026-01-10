---
created: 2025-12-31
tags: [type/project]
---

# Autonomous Agent Template

A reusable template for building long-running autonomous agents using Claude Agent SDK.

## Requirements

| Requirement | Version | Check Command |
|-------------|---------|---------------|
| **Python** | 3.10+ | `python3 --version` |
| **Claude Code CLI** | Latest | `claude --version` |
| **claude-code-sdk** | ≥0.0.25 | `pip3 show claude-code-sdk` |

> **⚠️ IMPORTANT:** This template requires Python 3.10 or higher. If `python3 --version` shows 3.9 or lower, see [Python Installation](#python-installation) below.

### Verify Setup

Before running the agent, verify all prerequisites are installed:

```bash
./scripts/preflight.sh
```

This script checks:
- Python 3.10+ installed
- Node.js installed (for browser automation)
- Git installed
- Claude authentication configured
- claude-code-sdk package installed

**Fix any errors before proceeding.** Warnings are informational.

## Quick Start

```bash
# 1. Verify Python version (MUST be 3.10+)
python3 --version

# 2. Install the SDK
pip3 install claude-code-sdk

# 3. Authenticate with Claude
claude login

# 4. Run the agent
python3 autonomous_agent.py --project-dir ./my-project
```

## Usage

1. **Edit `prompts/app_spec.txt`** with your application specification
2. **Run the agent** with your project directory
3. **Let it work** - the agent will create features, implement them, and test them

## How It Works

This template implements the **two-agent pattern**:

1. **Initializer Agent** (Session 1): Creates feature list, init script, and project structure
2. **Coding Agent** (Sessions 2+): Implements one feature at a time, tests, commits

### Key Files Created

| File | Purpose |
|------|---------|
| `feature_list.json` | Source of truth for all features |
| `claude-progress.txt` | Session notes and handoff information |
| `init.sh` | Environment setup script |

## Command Line Options

```bash
python3 autonomous_agent.py \
  --project-dir ./my-app \      # Project directory
  --max-iterations 5 \          # Limit iterations (optional)
  --model claude-sonnet-4-5 \   # Model to use (optional)
  --feature-count 50            # Number of features (optional)
```

## Customization

### Application Specification

Edit `prompts/app_spec.txt` to define your application:
- Technology stack
- Features
- UI/UX requirements

### Security Settings

Edit `utils/security.py` to modify allowed bash commands.

### MCP Servers

Edit `agents/client.py` to add additional MCP servers.

## Authentication

Two options (choose one):

### Option 1: Claude Pro/Max Subscription (Recommended)

```bash
# Login once - uses your Claude subscription
claude login

# Then run agents - no API key needed!
python3 autonomous_agent.py --project-dir ./my-app
```

### Option 2: API Key (Pay-as-you-go)

```bash
# Set your API key
export ANTHROPIC_API_KEY='sk-ant-...'

# Run agents
python3 autonomous_agent.py --project-dir ./my-app
```

Get API key from: https://console.anthropic.com/

---

## Known Limitations

### Browser Automation

The agent uses Puppeteer MCP for browser testing. On first run, you may need to grant permissions when prompted. If you see permission errors for MCP tools, restart the agent session.

### Git Remote

After creating a project with the template, your git remote may not be configured. To push your work:

```bash
# Option 1: Create repo manually
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main

# Option 2: Use GitHub CLI
gh repo create my-project --private --source=. --remote=origin --push
```

### Sandbox Restrictions

The agent runs in a security sandbox. Some commands are restricted:
- **Blocked:** `rm`, `rmdir` (prevents accidental deletion)
- **Blocked:** `sudo`, `su` (no privilege escalation)
- **Restricted:** `pkill` (only dev processes: node, npm, python, etc.)

See `GUARDRAILS.md` for the complete list of allowed commands.

### Session Duration

Each agent session typically runs 15-30 minutes before needing context refresh. The harness automatically restarts with fresh context. For complex applications:
- **Session 1 (Initializer):** May take 10-20+ minutes to generate 50 features
- **Sessions 2+:** Typically 5-15 minutes per feature

---

## Python Installation

If your system Python is older than 3.10, here's how to install a newer version:

### macOS (Homebrew)

```bash
# Install Python 3.11
brew install python@3.11

# Verify installation
python3.11 --version

# Use it to run the agent
python3.11 autonomous_agent.py --project-dir ./my-app
```

### macOS/Linux (pyenv)

```bash
# Install pyenv
curl https://pyenv.run | bash

# Install Python 3.11
pyenv install 3.11

# Set as local version for this project
pyenv local 3.11

# Now python3 will use 3.11
python3 --version
```

### Windows

1. Download Python 3.11+ from https://www.python.org/downloads/
2. During installation, check "Add Python to PATH"
3. Open new terminal and verify: `python --version`

### Virtual Environment (Any Platform)

```bash
# Create venv with Python 3.11
python3.11 -m venv venv

# Activate it
source venv/bin/activate  # Linux/macOS
# OR: venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt
```

---

## Based On

- [Claude Quickstarts - Autonomous Coding](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)
- [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
