#!/bin/bash

# Finhay Branch Naming Convention Hook
# Enforces branch naming pattern: type/issue-number-description
# Examples: feature/HIGH-123-add-login, bugfix/SIX-456-fix-crash, hotfix/urgent-fix

set -e

BRANCH_NAME=$(git symbolic-ref --short HEAD 2>/dev/null)

# Exit successfully if not in a git repo or in detached HEAD state
if [ -z "$BRANCH_NAME" ]; then
    exit 0
fi

# Branch naming pattern
# Format: (feature|bugfix|hotfix|release|chore)/issue-number-description
# Also allow protected branches: main, master, develop, release
PATTERN="^(feature|bugfix|hotfix|release|chore)\/.+$|^(main|master|develop|release)$"

if ! [[ $BRANCH_NAME =~ $PATTERN ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Branch name '$BRANCH_NAME' doesn't follow Finhay convention!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "✅ Valid branch name formats:"
    echo ""
    echo "  feature/add-trading-feature"
    echo "  feature/HIGH-123-add-login"
    echo "  bugfix/fix-login-issue"
    echo "  bugfix/SIX-456-fix-crash"
    echo "  hotfix/critical-data-fix"
    echo "  chore/update-dependencies"
    echo "  release/v1.2.0"
    echo ""
    echo "📋 Format: <type>/<description>"
    echo ""
    echo "Types:"
    echo "  • feature  - New feature development"
    echo "  • bugfix   - Bug fixes"
    echo "  • hotfix   - Urgent production fixes"
    echo "  • release  - Release preparation"
    echo "  • chore    - Maintenance tasks"
    echo ""
    echo "Protected branches (no pattern required):"
    echo "  main, master, develop, release"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
fi

exit 0
