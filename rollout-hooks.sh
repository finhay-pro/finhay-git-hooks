#!/bin/bash

# Rollout Script for Finhay Git Hooks
# This script helps deploy pre-commit hooks to multiple repositories

set -e

HOOKS_REPO="https://github.com/finhay-pro/finhay-git-hooks"
HOOKS_VERSION="v1.0.0"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Finhay Git Hooks Rollout Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "❌ pre-commit is not installed!"
    echo "Install it with: pip install pre-commit"
    exit 1
fi

# Function to setup hooks in a repository
setup_repository() {
    local repo_path=$1
    local repo_name=$(basename "$repo_path")
    
    echo "📦 Setting up: $repo_name"
    
    # Check if directory exists and is a git repository
    if [ ! -d "$repo_path/.git" ]; then
        echo "⚠️  Skipping $repo_name (not a git repository)"
        echo ""
        return
    fi
    
    cd "$repo_path"
    
    # Backup existing config if it exists
    if [ -f .pre-commit-config.yaml ]; then
        echo "  📋 Backing up existing .pre-commit-config.yaml"
        cp .pre-commit-config.yaml .pre-commit-config.yaml.backup
    fi
    
    # Create or update .pre-commit-config.yaml
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
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: detect-private-key
      - id: check-added-large-files
        args: ['--maxkb=500']

  # Add language-specific hooks below as needed
  # - repo: https://github.com/pre-commit/mirrors-eslint
  #   rev: v8.56.0
  #   hooks:
  #     - id: eslint
EOF
    
    # Install hooks
    echo "  🔧 Installing pre-commit hooks..."
    pre-commit install > /dev/null 2>&1
    pre-commit install --hook-type commit-msg > /dev/null 2>&1
    
    # Test installation
    echo "  ✅ Hooks installed successfully!"
    
    # Optionally run on all files (commented out to avoid breaking during rollout)
    # echo "  🧪 Testing hooks..."
    # pre-commit run --all-files || true
    
    echo ""
}

# Main execution
echo "This script will setup pre-commit hooks in multiple repositories."
echo ""
echo "Usage:"
echo "  1. Automatic mode (from a parent directory):"
echo "     ./rollout-hooks.sh /path/to/microservices-parent"
echo ""
echo "  2. Manual mode (specify repositories):"
echo "     Edit this script and add repository paths to REPOSITORIES array"
echo ""

# Option 1: Automatic - scan a parent directory for git repositories
if [ $# -eq 1 ]; then
    PARENT_DIR=$1
    
    if [ ! -d "$PARENT_DIR" ]; then
        echo "❌ Directory not found: $PARENT_DIR"
        exit 1
    fi
    
    echo "📁 Scanning for git repositories in: $PARENT_DIR"
    echo ""
    
    # Find all git repositories (max depth 2)
    for repo in $(find "$PARENT_DIR" -maxdepth 2 -type d -name ".git" -exec dirname {} \;); do
        setup_repository "$repo"
    done
    
# Option 2: Manual - list specific repositories
else
    # CUSTOMIZE THIS: Add your repository paths here
    REPOSITORIES=(
        # Example:
        # "/path/to/trading-service"
        # "/path/to/user-service"
        # "/path/to/order-service"
    )
    
    if [ ${#REPOSITORIES[@]} -eq 0 ]; then
        echo "⚠️  No repositories configured!"
        echo ""
        echo "Please either:"
        echo "  1. Run with parent directory: ./rollout-hooks.sh /path/to/parent"
        echo "  2. Edit this script and add repositories to REPOSITORIES array"
        exit 1
    fi
    
    for repo in "${REPOSITORIES[@]}"; do
        setup_repository "$repo"
    done
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Rollout complete!"
echo ""
echo "Next steps for each repository:"
echo "  1. Review the .pre-commit-config.yaml file"
echo "  2. Add language-specific hooks if needed"
echo "  3. Test: pre-commit run --all-files"
echo "  4. Commit the changes: git add .pre-commit-config.yaml"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
