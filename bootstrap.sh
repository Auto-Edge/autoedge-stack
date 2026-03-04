#!/usr/bin/env bash
set -e

# Detect the real user who ran the sudo command
REAL_USER=${SUDO_USER:-$(whoami)}
REAL_GROUP=$(id -gn $REAL_USER)

echo "🚀 Bootstrapping AutoEdge Stack..."

# 1. Clone Repositories
echo "📦 Cloning repositories..."
[ ! -d "frontend" ] && git clone https://github.com/Auto-Edge/auto-edge-web frontend
[ ! -d "backend" ] && git clone https://github.com/Auto-Edge/auto-edge-server backend
[ ! -d "ios-sdk" ] && git clone https://github.com/Auto-Edge/ios-sdk ios-sdk || echo "⚠️ iOS SDK clone skipped or failed (optional)"

# 2. Fix Docker Mount Permissions (Long-term solution)
# We create this folder now so Docker doesn't try to create it as root later and crash
echo "🔧 Pre-creating mount points to prevent Docker permission errors..."
mkdir -p frontend/node_modules

# 3. Handle "Double Git" Requirement
# Removes the .git history of this stack wrapper, so only the sub-projects are git repos
if [ -d ".git" ]; then
    echo "✂️  Detaching autoedge-stack from git history (removing root .git)..."
    rm -rf .git
    rm -f .gitignore
fi

# 4. Fix Ownership (Fixes "Dubious Ownership" & Permission Denied)
# Since you run this with sudo, we must give ownership back to your user account
echo "👤 Fixing file ownership for user: $REAL_USER..."
chown -R "$REAL_USER:$REAL_GROUP" .

echo "✅ Bootstrap complete! You can now run: docker compose up --build"
