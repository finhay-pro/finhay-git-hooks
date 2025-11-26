# Changelog

All notable changes to Finhay Git Hooks will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-11-26

### Added
- Initial release of Finhay Git Hooks
- Branch naming convention enforcement
  - Format: `<type>/<PROJECT>-<NUMBER>-<description>`
  - Supported types: feature, bugfix, hotfix, release, chore
  - Supported projects: FIN, VNSC, HI, TECH
  - Protected branches: main, master, develop, staging, production
- Commit message format enforcement
  - Conventional Commits format
  - Types: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert
  - Minimum subject length: 10 characters
- Comprehensive documentation and examples
- Rollout script for deploying to multiple repositories
- Example configuration files

### Project Setup
- `.pre-commit-hooks.yaml` - Hook definitions
- `hooks/check-branch-name.sh` - Branch naming validation
- `hooks/check-commit-msg.sh` - Commit message validation
- `README.md` - Complete documentation
- `rollout-hooks.sh` - Deployment automation script
- `example-config.yaml` - Reference configuration

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the first official release of the centralized Finhay Git Hooks repository.

**What's Included:**
- Branch naming convention hook
- Commit message format hook
- Comprehensive documentation
- Easy setup and rollout tools

**Getting Started:**
```bash
# In your project
pip install pre-commit

# Add to .pre-commit-config.yaml
repos:
  - repo: https://github.com/finhay-pro/finhay-git-hooks
    rev: v1.0.0
    hooks:
      - id: check-branch-name
      - id: check-commit-message

# Install
pre-commit install
pre-commit install --hook-type commit-msg
```

**For More Information:**
See [README.md](README.md) for complete setup instructions and usage guidelines.

---

[Unreleased]: https://github.com/finhay-pro/finhay-git-hooks/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/finhay-pro/finhay-git-hooks/releases/tag/v1.0.0
