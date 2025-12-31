#!/bin/bash
# preflight.sh - Pre-flight checks before running autonomous agent
#
# Run this before starting the agent to verify all dependencies are installed.
# Usage: ./scripts/preflight.sh

set -e

echo "=============================================="
echo "  Pre-flight Checks for Autonomous Agent"
echo "=============================================="
echo ""

ERRORS=0
WARNINGS=0

# =============================================================================
# CHECK 1: Python 3.10+
# =============================================================================
echo -n "Python 3.10+: "
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null)
if [[ -z "$PYTHON_VERSION" ]]; then
    echo "NOT FOUND"
    echo "  Install Python 3.10+ from: https://www.python.org/downloads/"
    ERRORS=$((ERRORS+1))
elif [[ $(echo "$PYTHON_VERSION < 3.10" | bc -l) -eq 1 ]]; then
    echo "OUTDATED ($PYTHON_VERSION)"
    echo "  Required: 3.10+, Found: $PYTHON_VERSION"
    echo "  Install Python 3.10+ from: https://www.python.org/downloads/"
    ERRORS=$((ERRORS+1))
else
    echo "OK ($PYTHON_VERSION)"
fi

# =============================================================================
# CHECK 2: Node.js (for Puppeteer browser automation)
# =============================================================================
echo -n "Node.js: "
NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [[ -z "$NODE_VERSION" ]]; then
    echo "NOT FOUND"
    echo "  Install Node.js from: https://nodejs.org/"
    echo "  (Required for Puppeteer browser automation)"
    WARNINGS=$((WARNINGS+1))
else
    echo "OK (v$NODE_VERSION)"
fi

# =============================================================================
# CHECK 3: Git installed
# =============================================================================
echo -n "Git: "
if ! command -v git &> /dev/null; then
    echo "NOT FOUND"
    echo "  Install Git from: https://git-scm.com/"
    ERRORS=$((ERRORS+1))
else
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo "OK ($GIT_VERSION)"
fi

# =============================================================================
# CHECK 4: Claude authentication
# =============================================================================
echo -n "Claude authentication: "
if command -v claude &> /dev/null; then
    echo "OK (Claude CLI available)"
elif [[ -n "$ANTHROPIC_API_KEY" ]]; then
    echo "OK (ANTHROPIC_API_KEY set)"
else
    echo "NOT CONFIGURED"
    echo "  Option 1: Run 'claude login' (uses Claude subscription)"
    echo "  Option 2: Set ANTHROPIC_API_KEY environment variable"
    ERRORS=$((ERRORS+1))
fi

# =============================================================================
# CHECK 5: claude-code-sdk installed
# =============================================================================
echo -n "claude-code-sdk: "
if python3 -c "import claude_code_sdk" 2>/dev/null; then
    SDK_VERSION=$(python3 -c "import claude_code_sdk; print(getattr(claude_code_sdk, '__version__', 'installed'))" 2>/dev/null)
    echo "OK ($SDK_VERSION)"
else
    echo "NOT INSTALLED"
    echo "  Run: pip3 install claude-code-sdk"
    ERRORS=$((ERRORS+1))
fi

# =============================================================================
# CHECK 6: Git remote (informational)
# =============================================================================
echo -n "Git remote: "
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
if [[ -z "$CURRENT_REMOTE" ]]; then
    echo "NOT SET"
    echo "  (Optional) Set a remote to push your work"
    WARNINGS=$((WARNINGS+1))
elif [[ "$CURRENT_REMOTE" == *"pushREC/agent-harness-template"* ]]; then
    echo "TEMPLATE REPO (should update)"
    echo "  Your remote points to the template repository."
    echo "  Update with: git remote set-url origin <your-repo-url>"
    WARNINGS=$((WARNINGS+1))
else
    echo "OK"
fi

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
echo "=============================================="
if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
    echo "  All checks passed!"
    echo "=============================================="
    echo ""
    echo "Ready to run the autonomous agent:"
    echo "  python3 autonomous_agent.py --project-dir ./my-project"
    exit 0
elif [[ $ERRORS -eq 0 ]]; then
    echo "  $WARNINGS warning(s), 0 errors"
    echo "=============================================="
    echo ""
    echo "You can proceed, but consider fixing warnings first."
    echo "  python3 autonomous_agent.py --project-dir ./my-project"
    exit 0
else
    echo "  $ERRORS error(s), $WARNINGS warning(s)"
    echo "=============================================="
    echo ""
    echo "Please fix the errors above before running the agent."
    exit 1
fi
