# Agent Harness Template - Claude Instructions

## Project Overview

This project contains a reusable template for building long-running autonomous agents using the Claude Agent SDK. It implements the two-agent pattern from Anthropic's "Effective harnesses for long-running agents" guide.

## Key Files

| File | Purpose |
|------|---------|
| `template/` | The actual template to copy for new projects |
| `examples/` | Example application specifications |
| `docs/` | Pattern and usage documentation |

## When Working on This Project

### DO:
- Test changes against the example app specs
- Keep the template generic and reusable
- Update documentation when changing patterns
- Maintain backwards compatibility with existing app specs

### DON'T:
- Add project-specific code to the template
- Remove security features without explicit approval
- Change the feature_list.json schema without updating docs

## Template Structure

```
template/
├── autonomous_agent.py      # Entry point
├── agents/                  # Session logic
├── prompts/                 # Prompt templates
├── utils/                   # Security, progress, prompts
└── config/                  # Settings
```

## Testing Changes

To test changes to the template:

```bash
cd template/
export ANTHROPIC_API_KEY=your-key
python3 autonomous_agent.py --project-dir /tmp/test-project --max-iterations 2
```

## Related Resources

- [[AGENT-HARNESS-TEMPLATE-README]] - Project hub
- [[3-Resources/claude-agent-sdk/MASTER-AGENT-SDK-REFERENCE]] - SDK docs
- [[3-Resources/claude-agent-sdk/09-long-running-agents-patterns]] - Patterns guide
