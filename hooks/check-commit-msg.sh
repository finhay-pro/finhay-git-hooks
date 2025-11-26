#!/bin/bash

# Finhay Commit Message Convention Hook
# Enforces conventional commit format: type(scope): subject
# Based on https://www.conventionalcommits.org/

set -e

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Skip merge commits and revert commits (they have their own format)
if [[ $COMMIT_MSG =~ ^Merge ]] || [[ $COMMIT_MSG =~ ^Revert ]]; then
    exit 0
fi

# Conventional commits pattern
# Format: type(scope): subject OR type: subject
# Subject must be at least 10 characters
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\(.+\))?: .{10,}"

if ! [[ $COMMIT_MSG =~ $PATTERN ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Invalid commit message format!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 Format: <type>(<scope>): <subject>"
    echo ""
    echo "✅ Examples:"
    echo ""
    echo "  feat(auth): add two-factor authentication support"
    echo "  fix(trading): resolve order execution timeout issue"
    echo "  docs(api): update trading API documentation"
    echo "  refactor(user): simplify user profile update logic"
    echo "  perf(database): optimize bond query performance"
    echo "  test(order): add unit tests for order validation"
    echo ""
    echo "📋 Commit Types:"
    echo ""
    echo "  • feat      - New feature"
    echo "  • fix       - Bug fix"
    echo "  • docs      - Documentation changes"
    echo "  • style     - Code style/formatting (no logic change)"
    echo "  • refactor  - Code refactoring (no feature/fix)"
    echo "  • perf      - Performance improvements"
    echo "  • test      - Adding or updating tests"
    echo "  • chore     - Maintenance tasks, dependencies"
    echo "  • build     - Build system changes"
    echo "  • ci        - CI/CD configuration changes"
    echo ""
    echo "💡 Tips:"
    echo "  • Use scope to specify which part of code is affected"
    echo "  • Subject must be at least 10 characters"
    echo "  • Use imperative mood (add, not added/adds)"
    echo "  • Don't capitalize first letter of subject"
    echo "  • No period at the end"
    echo ""
    echo "Your commit message:"
    echo "  '$COMMIT_MSG'"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
fi

# Additional validation: Check if subject starts with lowercase
SUBJECT=$(echo "$COMMIT_MSG" | sed -E 's/^[a-z]+(\([^)]+\))?: //')
FIRST_CHAR=$(echo "$SUBJECT" | cut -c1)

if [[ $FIRST_CHAR =~ [A-Z] ]]; then
    echo ""
    echo "⚠️  Warning: Subject should start with lowercase letter"
    echo "   Current: '$SUBJECT'"
    echo "   Example: 'add two-factor authentication' (not 'Add...')"
    echo ""
    # Note: This is just a warning, not blocking the commit
    # Remove the exit below to make it blocking
    # exit 1
fi

exit 0
