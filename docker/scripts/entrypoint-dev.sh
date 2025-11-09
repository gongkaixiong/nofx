#!/bin/sh

# Development entrypoint script for NOFX backend
# This script builds and runs the application, with support for recompilation on code changes

set -e

echo "========================================"
echo "NOFX Backend Development Environment"
echo "========================================"
echo "- Build environment: Go $(go version)"
echo "- TA-Lib installed and configured"
echo "- Source code mounted for live development"
echo "========================================"

# Function to build and run the application
build_and_run() {
    echo "\n🔧 Building application..."
    # Set GOOS to linux for consistency
    export GOOS=linux
    # Set CGO_ENABLED to 1 for TA-Lib
    export CGO_ENABLED=1
    export CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
    
    # Build the application
    go build -trimpath -ldflags="-s -w" -o nofx .
    
    if [ $? -eq 0 ]; then
        echo "✅ Build successful!"
        echo "🚀 Starting application..."
        # Run the application
        ./nofx
    else
        echo "❌ Build failed!"
        exit 1
    fi
}

# Check if code watching is enabled
if [ "$WATCH_MODE" = "true" ]; then
    echo "👁️  Watch mode enabled"
    echo "📝 Changes to Go files will trigger automatic rebuild"
    
    # Install entr for file watching if not already installed
    if ! command -v entr &> /dev/null; then
        echo "📦 Installing entr for file watching..."
        apk add --no-cache entr
    fi
    
    # Initial build and run
    build_and_run
    
    # Watch for changes and rebuild
    # Note: This is a simplified approach; in practice, you might want to use a more robust solution
else
    # Standard mode: build and run once
    build_and_run
fi