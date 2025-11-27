# One-Line Install Guide

Share this with your team members:

## For New Projects or Team Members

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh)"
```

## What This Does

1. ✅ Checks if pre-commit is installed (installs if missing)
2. ✅ Creates `.pre-commit-config.yaml` with Finhay hooks
3. ✅ Installs git hooks in the project
4. ✅ Optionally runs checks on existing files

## Copy-Paste for Slack/Email

```
🔧 Setting up Git Hooks

Run this in your project directory:

cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh | bash

This will set up:
✅ Branch naming enforcement (feature/description, bugfix/description, etc.)
✅ Commit message format (feat(scope): description)

Full docs: https://github.com/finhay-pro/finhay-git-hooks
```

## For Different Versions

```bash
# Install specific version
/bin/bash -c "$(FINHAY_HOOKS_VERSION=v1.0.1 curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh)"

# Always use latest
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/install.sh)"
```

## Alternative: Manual Install

If someone doesn't want to use curl | bash:

```bash
# 1. Install pre-commit
pip install pre-commit

# 2. Download the config
curl -o .pre-commit-config.yaml https://raw.githubusercontent.com/finhay-pro/finhay-git-hooks/main/example-config.yaml

# 3. Install hooks
pre-commit install
pre-commit install --hook-type commit-msg
```

## Troubleshooting

**"pre-commit: command not found"**
```bash
pip install pre-commit
# or
brew install pre-commit
```

**"Not in a git repository"**
```bash
# Make sure you're in the project root
cd /path/to/your/project
# Then run the install script
```

**"Permission denied"**
```bash
# Make sure you have write access to the directory
ls -la .git/
```

## After Installation

Hooks run automatically on every commit. Test with:

```bash
# Create a test branch (will pass)
git checkout -b feature/test-hooks

# Try an invalid branch (will fail)
git checkout -b my-test  # ❌ Will show error

# Make a valid commit (will pass)
git commit -m "feat(test): add new feature"

# Try an invalid commit (will fail)
git commit -m "fixed bug"  # ❌ Will show error
```
