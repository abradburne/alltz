#!/bin/bash
# alltz Release Script

set -e

VERSION="0.1.0"
TARGETS=("x86_64-apple-darwin" "aarch64-apple-darwin" "x86_64-unknown-linux-gnu")

echo "🚀 Building alltz v${VERSION} for multiple targets..."

# Clean previous builds
cargo clean
rm -rf dist
mkdir -p dist

# Build for each target
for target in "${TARGETS[@]}"; do
    echo "📦 Building for ${target}..."
    
    # Install target if not present
    rustup target add "$target" 2>/dev/null || true
    
    # Build release binary
    cargo build --release --target "$target"
    
    # Create distribution package
    cp "target/${target}/release/alltz" "dist/alltz-${target}"
    tar -czf "dist/alltz-v${VERSION}-${target}.tar.gz" -C dist "alltz-${target}"
    
    echo "✅ Created dist/alltz-v${VERSION}-${target}.tar.gz"
done

# Create universal binary for macOS (if both Intel and ARM builds exist)
if [ -f "dist/alltz-x86_64-apple-darwin" ] && [ -f "dist/alltz-aarch64-apple-darwin" ]; then
    echo "🔨 Creating universal macOS binary..."
    lipo -create -output "dist/alltz-universal" \
         "dist/alltz-x86_64-apple-darwin" \
         "dist/alltz-aarch64-apple-darwin"
    tar -czf "dist/alltz-v${VERSION}-universal-macos.tar.gz" -C dist "alltz-universal"
    echo "✅ Created universal macOS binary"
fi

# Generate checksums
cd dist
shasum -a 256 *.tar.gz > checksums.txt
cd ..

echo ""
echo "🎉 Release packages created in dist/:"
ls -la dist/*.tar.gz
echo ""
echo "📋 Checksums:"
cat dist/checksums.txt