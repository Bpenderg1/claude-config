#!/bin/bash

# Claude Config Installation Script
# Installs SME Prototype commands, agents, and settings to ~/.claude/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "========================================"
echo "Claude SME Config Installer"
echo "========================================"
echo ""
echo "This will install to: $CLAUDE_DIR"
echo ""

# Create directories
echo "Creating directories..."
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/hooks"

# Copy commands
echo "Installing commands..."
cp "$SCRIPT_DIR/.claude/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true

# Copy agents
echo "Installing agents..."
cp "$SCRIPT_DIR/.claude/agents/"*.md "$CLAUDE_DIR/agents/" 2>/dev/null || true

# Copy hooks
echo "Installing hooks..."
cp "$SCRIPT_DIR/.claude/hooks/"*.md "$CLAUDE_DIR/hooks/" 2>/dev/null || true

# Copy settings (with backup if exists)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "Backing up existing settings.json..."
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
fi
echo "Installing settings..."
cp "$SCRIPT_DIR/.claude/settings.json" "$CLAUDE_DIR/"

echo ""
echo "========================================"
echo "Installation complete!"
echo "========================================"
echo ""
echo "Installed:"
echo "  - /sme-prototype command"
echo "  - security-gate agent"
echo "  - production-ready agent"
echo "  - permission-explainer hook"
echo "  - Base settings.json"
echo ""
echo "These are now available in ALL your projects."
echo ""
echo "Next steps:"
echo "  1. Open a project in Claude Code"
echo "  2. Run: /sme-prototype"
echo "  3. Or copy templates/CLAUDE.md.template to your project"
echo ""
