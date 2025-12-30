#!/bin/bash
# create-project.sh - Initialize a new autonomous agent project from template
#
# Usage:
#   ./create-project.sh my-new-project
#   ./create-project.sh /absolute/path/to/project
#
# Requirements:
#   - Python 3.10+ (check with: python3 --version)
#   - Git

set -e

# =============================================================================
# PYTHON VERSION CHECK (REQUIRED: 3.10+)
# =============================================================================
find_python() {
    # Try versioned Python commands first (most explicit)
    for cmd in python3.13 python3.12 python3.11 python3.10 python3 python; do
        if command -v "$cmd" &> /dev/null; then
            # Check if this version is >= 3.10
            MAJOR=$($cmd -c 'import sys; print(sys.version_info.major)' 2>/dev/null)
            MINOR=$($cmd -c 'import sys; print(sys.version_info.minor)' 2>/dev/null)

            if [ "$MAJOR" = "3" ] && [ "$MINOR" -ge 10 ]; then
                PYTHON_CMD="$cmd"
                PYTHON_VERSION="$MAJOR.$MINOR"
                return 0
            fi
        fi
    done
    return 1
}

check_python_version() {
    if find_python; then
        echo "✓ Python $PYTHON_VERSION detected ($PYTHON_CMD)"
    else
        echo "ERROR: Python 3.10+ not found."
        echo ""

        # Show what versions ARE available
        echo "Available Python versions on your system:"
        for cmd in python3 python python3.9 python3.8; do
            if command -v "$cmd" &> /dev/null; then
                VER=$($cmd --version 2>&1)
                echo "  - $cmd: $VER"
            fi
        done

        echo ""
        echo "This template requires Python 3.10 or higher."
        echo ""
        echo "Options to install Python 3.10+:"
        echo "  1. Download from: https://www.python.org/downloads/"
        echo "  2. Homebrew (macOS): brew install python@3.11"
        echo "  3. pyenv: pyenv install 3.11 && pyenv local 3.11"
        echo "  4. apt (Ubuntu/Debian): sudo apt install python3.11"
        echo ""
        echo "After installing, run this script again."
        exit 1
    fi
}

# Run the check
check_python_version

PROJECT_NAME="${1:-my-autonomous-project}"

# Handle relative vs absolute paths
if [[ "$PROJECT_NAME" = /* ]]; then
    PROJECT_DIR="$PROJECT_NAME"
else
    PROJECT_DIR="$(pwd)/$PROJECT_NAME"
fi

# Check if directory already exists
if [ -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' already exists"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

# Verify template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory not found at $TEMPLATE_DIR"
    exit 1
fi

echo "Creating new project: $PROJECT_DIR"
echo ""

# Copy template contents
cp -r "$TEMPLATE_DIR" "$PROJECT_DIR"

# Enter the new project directory
cd "$PROJECT_DIR"

# Remove any cached files that shouldn't be in a fresh project
rm -rf __pycache__ */__pycache__ */*/__pycache__
rm -f logs/*.json

# Initialize git repository
git init -q
git add .
git commit -q -m "Initial project from agent-harness-template"

echo "Project created successfully!"
echo ""
echo "=============================================="
echo "  NEXT STEPS"
echo "=============================================="
echo ""
echo "  1. Enter the project directory:"
echo "     cd $PROJECT_DIR"
echo ""
echo "  2. Edit your application specification:"
echo "     Edit prompts/app_spec.txt"
echo ""
echo "  3. Authenticate (choose one):"
echo "     Option A: claude login     (uses your Claude subscription)"
echo "     Option B: export ANTHROPIC_API_KEY='sk-ant-...'  (API key)"
echo ""
echo "  4. Run the autonomous agent:"
echo "     python3 autonomous_agent.py --project-dir ./my-app"
echo ""
echo "  Optional flags:"
echo "     --max-iterations N    Limit number of sessions"
echo "     --feature-count N     Target number of features (default: 50)"
echo "     --model MODEL         Claude model to use"
echo ""
echo "=============================================="
