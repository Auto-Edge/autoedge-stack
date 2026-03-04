#!/usr/bin/env bash
set -e

git clone https://github.com/Auto-Edge/auto-edge-web frontend
git clone https://github.com/Auto-Edge/auto-edge-server backend
git clone https://github.com/Auto-Edge/ios-sdk ios-sdk || true 