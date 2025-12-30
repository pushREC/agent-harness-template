#!/bin/bash
# create-project.sh - Initialize a new autonomous agent project from template
#
# Usage:
#   ./create-project.sh my-new-project
#   ./create-project.sh /absolute/path/to/project

set -e

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
