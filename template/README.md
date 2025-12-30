# Autonomous Agent Template

A reusable template for building long-running autonomous agents using Claude Agent SDK.

## Quick Start

```bash
# Make sure you're logged into Claude Code
claude login

# Run the agent (uses your Claude Code subscription)
python autonomous_agent.py --project-dir ./my-project
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
python autonomous_agent.py \
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
python autonomous_agent.py --project-dir ./my-app
```

### Option 2: API Key (Pay-as-you-go)

```bash
# Set your API key
export ANTHROPIC_API_KEY='sk-ant-...'

# Run agents
python autonomous_agent.py --project-dir ./my-app
```

Get API key from: https://console.anthropic.com/

## Requirements

- Python 3.10+
- Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
- Claude Agent SDK: `pip install claude-code-sdk`

## Based On

- [Claude Quickstarts - Autonomous Coding](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)
- [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
