#!/bin/bash

# Finhay Git Hooks - Quick Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh | bash

set -e

HOOKS_REPO="https://github.com/finhay-pro/finhay-git-hooks"
HOOKS_VERSION="${FINHAY_HOOKS_VERSION:-v1.0.1}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Finhay Git Hooks - Quick Install"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: Not in a git repository!"
    echo ""
    echo "Please run this script from the root of your git project:"
    echo "  cd /path/to/your/project"
    echo "  curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh | bash"
    echo ""
    exit 1
fi

PROJECT_NAME=$(basename "$(pwd)")
echo "📦 Project: $PROJECT_NAME"
echo ""

# Check if pre-commit is installed
echo "🔍 Checking for pre-commit..."
if ! command -v pre-commit &> /dev/null; then
    echo "⚠️  pre-commit not found. Installing..."

    # Try pip3 first, then pip
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
    elif command -v pip &> /dev/null; then
        pip install pre-commit
    else
        echo "❌ Error: Neither pip nor pip3 found!"
        echo ""
        echo "Please install Python and pip first:"
        echo "  macOS: brew install python"
        echo "  Ubuntu: sudo apt install python3-pip"
        echo ""
        exit 1
    fi

    echo "✅ pre-commit installed"
else
    echo "✅ pre-commit already installed ($(pre-commit --version))"
fi
echo ""

read -p "🧪 Generate .pre-commit-config.yaml for this project? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Backup existing config if it exists
    if [ -f .pre-commit-config.yaml ]; then
        echo "📋 Found existing .pre-commit-config.yaml"
        echo "   Creating backup: .pre-commit-config.yaml.backup"
        cp .pre-commit-config.yaml .pre-commit-config.yaml.backup
        echo ""
    fi

    # Create .pre-commit-config.yaml
    echo "📝 Creating .pre-commit-config.yaml..."
    cat > .pre-commit-config.yaml << EOF
repos:
# Finhay shared hooks
- repo: $HOOKS_REPO
    rev: $HOOKS_VERSION
    hooks:
    - id: check-branch-name
    - id: check-commit-message

# Standard pre-commit hooks
- repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
    - id: trailing-whitespace
    - id: end-of-file-fixer
    - id: check-yaml
    - id: check-json
    - id: check-merge-conflict
    - id: detect-private-key
    - id: check-added-large-files
        args: ['--maxkb=500']
EOF

    echo "✅ Configuration created"
    echo ""
fi

# Install hooks
echo "🔧 Installing git hooks..."
pre-commit install > /dev/null 2>&1
pre-commit install --hook-type commit-msg > /dev/null 2>&1
echo "✅ Hooks installed"
echo ""

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Git hooks are now active in this repository."
echo ""
echo "📋 Conventions:"
echo "   Branch naming: feature/description, bugfix/description, etc."
echo "   Commit format: feat(scope): description"
echo ""
echo "📚 Full documentation:"
echo "   $HOOKS_REPO"
echo ""
echo "🎯 Next steps:"
echo "   Start coding! Hooks will run automatically on each commit."
echo ""
echo "💡 Need help? Contact #Backend team on Google Chat"
echo ""
