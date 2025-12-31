# Agent Guardrails

This document defines the security boundaries and available commands for the autonomous agent.
These rules are enforced in `utils/security.py`.

---

## Available Bash Commands

The agent runs in a security sandbox. Here's what's allowed:

### Always Allowed

**File Operations:**
- `ls`, `cat`, `head`, `tail`, `wc`, `grep`, `find`
- `cp`, `mkdir`, `touch`
- `pwd`, `cd`

**Development:**
- `npm`, `node`, `npx`
- `python`, `python3`, `pip`, `pip3`, `uv`
- `git` (all subcommands)
- `make`, `cargo`, `go`

**Utilities:**
- `curl`, `jq`
- `echo`, `printf`, `tee`
- `sort`, `uniq`, `tr`, `cut`, `sed`, `awk`
- `xargs`, `date`, `env`, `which`
- `basename`, `dirname`, `realpath`
- `test`, `[`, `true`, `false`
- `ps`, `lsof`, `sleep`, `timeout`

### Restricted (Extra Validation)

- `pkill` - Only dev processes allowed: `node`, `npm`, `npx`, `vite`, `next`, `python`, `python3`, `uvicorn`, `gunicorn`
- `chmod` - Only `+x` mode allowed (making files executable)
- `init.sh` - Only `./init.sh`, `bash init.sh`, or `sh init.sh`

### Blocked (Not Allowed)

- `rm`, `rmdir` - Prevents accidental file deletion
- `sudo`, `su` - No privilege escalation
- `wget` - Use `curl` instead
- `ssh`, `scp` - No remote access
- `dd`, `mkfs` - No disk operations

---

## Customizing Security

To add or remove allowed commands, edit `utils/security.py`:

```python
ALLOWED_COMMANDS = {
    "ls", "cat", ...
    # Add your command here
    "your_command",
}
```

For commands needing extra validation, add them to `COMMANDS_NEEDING_EXTRA_VALIDATION` and implement a validation function.

---

## Best Practices

### For the Agent

1. **Always verify** before creating files - check if similar files exist
2. **Commit incrementally** - small commits after each feature
3. **Update progress** - write to `claude-progress.txt` for session handoff
4. **Handle errors** - if blocked, explain why and suggest alternative

### For the User

1. **Run preflight checks** - `./scripts/preflight.sh` before starting
2. **Review commits** - check `git log` periodically
3. **Monitor progress** - watch `feature_list.json` for completion status

---

## Troubleshooting

### Command Blocked

If you see a blocked command error:
1. Check if the command is in `ALLOWED_COMMANDS`
2. Check if extra validation is failing
3. Consider if there's an alternative approach

### Permission Denied

For file permission issues:
1. Use `chmod +x` to make scripts executable
2. Ensure you own the files you're modifying

### MCP Tool Permissions

If browser automation tools are blocked:
1. Restart the agent session
2. Grant permissions when prompted
3. Check Claude Code settings for MCP permissions

---

*This document is the single source of truth for agent guardrails.*
*See also: `utils/security.py` for programmatic enforcement.*
