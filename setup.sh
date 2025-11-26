#!/bin/bash

# Setup script for finhay-git-hooks repository
# Run this after cloning or setting up the repository

echo "🔧 Setting up finhay-git-hooks..."
echo ""

# Make all scripts executable
echo "Making scripts executable..."
chmod +x hooks/check-branch-name.sh
chmod +x hooks/check-commit-msg.sh
chmod +x rollout-hooks.sh
chmod +x test-hooks.sh

echo "✅ Scripts are now executable"
echo ""
echo "Next steps:"
echo ""
echo "1. Test the hooks:"
echo "   ./test-hooks.sh"
echo ""
echo "2. Initialize git repository:"
echo "   git init"
echo "   git add ."
echo "   git commit -m \"feat: initial setup of Finhay centralized git hooks\""
echo ""
echo "3. Push to GitHub:"
echo "   git remote add origin git@github.com:finhay-pro/finhay-git-hooks.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. Create version tag:"
echo "   git tag -a v1.0.0 -m \"Release v1.0.0: Initial release\""
echo "   git push origin v1.0.0"
echo ""
