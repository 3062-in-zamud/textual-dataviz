#!/usr/bin/env bash
set -euo pipefail

# textual-dataviz installer
# Creates symlinks for Claude Code skill and command integration

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="${HOME}/.claude/skills"
COMMANDS_DIR="${HOME}/.claude/commands"

echo "Installing textual-dataviz..."

# Create target directories if needed
mkdir -p "${SKILLS_DIR}"
mkdir -p "${COMMANDS_DIR}"

# Remove old visualize skill if it exists
if [ -d "${SKILLS_DIR}/visualize" ] && [ ! -L "${SKILLS_DIR}/visualize" ]; then
    echo "Found old visualize skill at ${SKILLS_DIR}/visualize"
    echo "  -> Will be replaced by textual-dataviz"
    read -r -p "Remove old visualize skill? [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -rf "${SKILLS_DIR}/visualize"
        echo "  -> Removed"
    fi
fi

# Create skill symlink
if [ -L "${SKILLS_DIR}/textual-dataviz" ]; then
    echo "Removing existing symlink: ${SKILLS_DIR}/textual-dataviz"
    rm "${SKILLS_DIR}/textual-dataviz"
fi
ln -s "${SCRIPT_DIR}/skills/textual-dataviz" "${SKILLS_DIR}/textual-dataviz"
echo "Linked skill: ${SKILLS_DIR}/textual-dataviz -> ${SCRIPT_DIR}/skills/textual-dataviz"

# Copy command file
cp "${SCRIPT_DIR}/commands/textual-dataviz.md" "${COMMANDS_DIR}/textual-dataviz.md"
echo "Copied command: ${COMMANDS_DIR}/textual-dataviz.md"

echo ""
echo "Installation complete!"
echo "  Skill: /textual-dataviz"
echo "  Triggers: 「可視化して」「グラフにして」「visualize」etc."
echo ""
echo "To uninstall:"
echo "  rm ${SKILLS_DIR}/textual-dataviz"
echo "  rm ${COMMANDS_DIR}/textual-dataviz.md"
