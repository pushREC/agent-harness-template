---
created: 2025-12-28
tags:
  - type/documentation
  - topic/agents
  - topic/security
---

# Security Model

Multi-layered security for autonomous agent execution.

## Defense in Depth

Three layers of protection:

### Layer 1: OS-Level Sandbox

Enabled via Claude SDK:

```python
security_settings = {
    "sandbox": {
        "enabled": True,
        "autoAllowBashIfSandboxed": True
    }
}
```

**What it does:**
- Isolates bash command execution
- Prevents filesystem escape
- Blocks network access outside allowed domains

### Layer 2: Filesystem Restrictions

Permissions limit file operations to project directory:

```python
"permissions": {
    "allow": [
        "Read(./**)",
        "Write(./**)",
        "Edit(./**)",
        "Glob(./**)",
        "Grep(./**)"
    ]
}
```

**What it does:**
- Only allows operations within project directory
- Blocks access to system files
- Prevents reading sensitive data outside project

### Layer 3: Command Allowlist

Hook validates bash commands before execution:

```python
ALLOWED_COMMANDS = {
    # File inspection
    "ls", "cat", "head", "tail", "wc", "grep",
    # File operations
    "cp", "mkdir", "chmod", "touch",
    # Development tools
    "npm", "node", "npx",
    "python", "python3", "pip",
    # Version control
    "git",
    # Process management
    "ps", "lsof", "sleep", "pkill",
}
```

**What it does:**
- Only permits explicitly allowed commands
- Validates sensitive commands (pkill, chmod)
- Blocks system administration commands

## Command Validation

### Basic Validation

Command must be in allowlist:

```python
for cmd in extract_commands(command):
    if cmd not in ALLOWED_COMMANDS:
        return {"decision": "block", "reason": f"Command '{cmd}' not allowed"}
```

### Extra Validation

Some commands need additional checks:

| Command | Validation |
|---------|------------|
| `pkill` | Only dev processes (node, npm, python) |
| `chmod` | Only +x mode (making executable) |
| `init.sh` | Only ./init.sh path |

Example:

```python
def validate_pkill_command(command_string):
    allowed_processes = {"node", "npm", "python", "vite", "next"}
    # Parse command, check target is in allowed list
```

## Hook Implementation

```python
async def bash_security_hook(input_data, tool_use_id=None, context=None):
    """Pre-tool-use hook that validates bash commands."""

    if input_data.get("tool_name") != "Bash":
        return {}  # Only validate Bash tool

    command = input_data.get("tool_input", {}).get("command", "")
    commands = extract_commands(command)

    # Check each command
    for cmd in commands:
        if cmd not in ALLOWED_COMMANDS:
            return {
                "decision": "block",
                "reason": f"Command '{cmd}' not in allowed list"
            }

        # Extra validation for sensitive commands
        if cmd in COMMANDS_NEEDING_EXTRA_VALIDATION:
            allowed, reason = validate_command(cmd, command)
            if not allowed:
                return {"decision": "block", "reason": reason}

    return {}  # Allow if all checks pass
```

## Extending the Allowlist

To add new commands, edit `utils/security.py`:

```python
ALLOWED_COMMANDS = {
    # ... existing commands ...
    "docker",      # Add Docker
    "cargo",       # Add Rust tooling
    "go",          # Add Go tooling
}
```

For commands needing extra validation:

```python
COMMANDS_NEEDING_EXTRA_VALIDATION = {
    "pkill", "chmod", "init.sh",
    "docker"  # Add new command
}

def validate_docker_command(command_string):
    # Only allow docker build and docker run
    allowed_subcommands = {"build", "run", "stop"}
    # ... validation logic ...
```

## Best Practices

1. **Principle of least privilege** - Only allow what's needed
2. **Fail-safe defaults** - Block if uncertain
3. **Validate compound commands** - Check all parts of `&&`, `||`, `;`
4. **Log blocked commands** - For debugging and audit

## Related

- [[3-Resources/claude-agent-sdk/02-hooks]]
- [[3-Resources/claude-agent-sdk/05-permissions]]
