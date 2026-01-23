#!/bin/bash

echo "🚀 Building PARfolio for Hostinger deployment..."
echo ""

# Clean previous deployment
echo "🧹 Cleaning previous build..."
rm -rf deploy
mkdir -p deploy

# Copy marketing files
echo "📄 Copying landing page files..."
cp marketing/index.html deploy/
cp marketing/style.css deploy/
cp marketing/script.js deploy/
cp -r marketing/assets deploy/
echo "   ✓ Landing page files copied"

# Build Flutter web app
echo ""
echo "🔨 Building Flutter web app..."
cd frontend
flutter build web --release --base-href "/app/"
BUILD_STATUS=$?
cd ..

if [ $BUILD_STATUS -ne 0 ]; then
  echo "   ✗ Flutter build failed!"
  exit 1
fi
echo "   ✓ Flutter app built successfully"

# Copy Flutter build
echo ""
echo "📦 Packaging Flutter app..."
mkdir -p deploy/app
cp -r frontend/build/web/* deploy/app/
echo "   ✓ Flutter app packaged"

# Show summary
echo ""
echo "✅ Build complete!"
echo ""
echo "📊 Deployment Summary:"
echo "   Location: ./deploy/"
echo "   Size: $(du -sh deploy/ | cut -f1)"
echo ""
echo "📤 Next Steps:"
echo "   1. Log into Hostinger File Manager"
echo "   2. Navigate to public_html/"
echo "   3. Upload all contents from ./deploy/"
echo ""
echo "🌐 After upload, test:"
echo "   - Landing page: https://yourdomain.com/"
echo "   - Flutter app:  https://yourdomain.com/app"
echo ""
