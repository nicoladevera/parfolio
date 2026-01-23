# PARfolio Deployment Guide

**Last Updated:** January 2026
**Flutter Version:** 3.38.7
**Target Platform:** Hostinger Static Hosting

---

## Overview

This guide covers how to build and deploy PARfolio to Hostinger. The app consists of:
- **Landing Page** (HTML/CSS/JS) at `marketing/`
- **Flutter Web App** at `frontend/`

The deployment process compiles both into static files that can be uploaded to any web host.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Building for Production](#building-for-production)
4. [Deployment Structure](#deployment-structure)
5. [Uploading to Hostinger](#uploading-to-hostinger)
6. [Testing Your Deployment](#testing-your-deployment)
7. [Troubleshooting](#troubleshooting)
8. [Automated Deployment Script](#automated-deployment-script)

---

## Prerequisites

Before deploying, ensure you have:

- **Flutter 3.38+** installed (`flutter --version` to check)
- Access to your **Hostinger account** with File Manager permissions
- The PARfolio repository cloned locally

---

## Project Structure

```
parfolio/
├── marketing/              # Landing page (HTML/CSS/JS)
│   ├── index.html         # Landing page entry point
│   ├── style.css          # Landing page styles
│   ├── script.js          # Landing page scripts
│   └── assets/            # Images and assets
│
├── frontend/              # Flutter web app
│   ├── lib/               # Dart source code
│   ├── web/               # Web-specific files
│   ├── pubspec.yaml       # Dependencies
│   └── build/web/         # Built files (generated)
│
└── deploy/                # Deployment folder (git-ignored)
    ├── index.html         # Landing page
    ├── style.css
    ├── script.js
    ├── assets/
    └── app/               # Flutter app (compiled)
```

---

## Building for Production

### Step 1: Navigate to Project Root

```bash
cd /path/to/parfolio
```

### Step 2: Build Flutter Web App

Navigate to the frontend directory and build:

```bash
cd frontend
flutter build web --release --base-href "/app/"
cd ..
```

**What this does:**
- Compiles Dart code to JavaScript
- Optimizes assets and fonts (tree-shaking)
- Generates static HTML/CSS/JS files
- Places output in `frontend/build/web/`
- Sets base URL to `/app/` for subdirectory deployment

**Build Output:**
- **Location:** `frontend/build/web/`
- **Size:** ~31 MB
- **Key Files:**
  - `index.html` - Entry point
  - `main.dart.js` - Compiled Flutter app (~3.2 MB)
  - `flutter.js` - Flutter engine
  - `canvaskit/` - Rendering engine
  - `assets/` - App assets

**Important Notes:**
- ✅ Use `--release` for production (optimized, no debug tools)
- ✅ Use `--base-href "/app/"` if deploying to `/app` subdirectory
- ❌ Don't use `--web-renderer` flag (removed in Flutter 3.38+)
- ⚠️ Build time: ~30-60 seconds depending on your machine

### Step 3: Organize Deployment Files

Create a deployment folder and copy files:

```bash
# Create fresh deploy directory
rm -rf deploy
mkdir -p deploy

# Copy landing page files
cp marketing/index.html deploy/
cp marketing/style.css deploy/
cp marketing/script.js deploy/
cp -r marketing/assets deploy/

# Copy Flutter build to /app subdirectory
mkdir -p deploy/app
cp -r frontend/build/web/* deploy/app/
```

**Result:**
```
deploy/                    # 40 MB total
├── index.html            # 12 KB - Landing page
├── style.css             # 1.5 KB
├── script.js             # 2.7 KB
├── assets/               # 8.5 MB - Landing page images
└── app/                  # 31 MB - Flutter web app
    ├── index.html
    ├── main.dart.js
    ├── flutter.js
    ├── assets/
    └── canvaskit/
```

---

## Deployment Structure

### How URLs Map to Files

When deployed to Hostinger, the structure maps to URLs like this:

| URL | File Served | Description |
|-----|-------------|-------------|
| `https://yourdomain.com/` | `deploy/index.html` | Landing page |
| `https://yourdomain.com/app` | `deploy/app/index.html` | Flutter app |
| `https://yourdomain.com/assets/hero.png` | `deploy/assets/hero.png` | Landing page image |
| `https://yourdomain.com/app/main.dart.js` | `deploy/app/main.dart.js` | Flutter compiled code |

### Landing Page Links

The landing page has multiple links to the Flutter app:
- Navigation: "Get Started" button → `/app`
- Hero section: "Start Recording" button → `/app`
- Mobile menu: "Get Started" link → `/app`

These links work because the Flutter app is deployed at `deploy/app/`.

---

## Uploading to Hostinger

### Option 1: File Manager (Recommended for First-Time Deployment)

1. **Log into Hostinger**
   - Go to [hpanel.hostinger.com](https://hpanel.hostinger.com)
   - Log in with your credentials

2. **Open File Manager**
   - Navigate to your hosting account
   - Click "File Manager"

3. **Navigate to Web Root**
   - Go to `public_html/` directory
   - This is where your website files live

4. **Upload Files**
   - **Delete old files** (if redeploying)
   - **Upload** all contents from `deploy/` folder:
     - `index.html`
     - `style.css`
     - `script.js`
     - `assets/` folder
     - `app/` folder
   - **Preserve folder structure** - `app/` must be a subdirectory

5. **Set Permissions** (if needed)
   - Files: `644` (rw-r--r--)
   - Folders: `755` (rwxr-xr-x)

**Upload Time:** ~5-10 minutes depending on internet speed (40 MB total)

### Option 2: FTP/SFTP (Faster for Updates)

1. **Get FTP Credentials** from Hostinger control panel
2. **Use FTP Client** (FileZilla, Cyberduck, etc.)
3. **Connect** to your host
4. **Upload** `deploy/` contents to `public_html/`

### Option 3: SSH/Terminal (Advanced)

If you have SSH access:

```bash
# Compress locally
tar -czf deploy.tar.gz deploy/

# Upload via SCP
scp deploy.tar.gz user@yourhost:/home/user/public_html/

# SSH in and extract
ssh user@yourhost
cd public_html
tar -xzf deploy.tar.gz --strip-components=1
rm deploy.tar.gz
```

---

## Testing Your Deployment

### 1. Check Landing Page

Visit: `https://yourdomain.com/`

**Expected:**
- ✅ Landing page loads correctly
- ✅ Images appear (hero image, feature cards)
- ✅ Fonts load (Inter, Libre Baskerville)
- ✅ Responsive design works on mobile

**Test:**
- Click "Get Started" buttons
- Check mobile menu works
- Verify all images load

### 2. Check Flutter App

Visit: `https://yourdomain.com/app`

**Expected:**
- ✅ Flutter app loads (may take 3-5 seconds first time)
- ✅ Loading spinner appears
- ✅ App UI renders correctly
- ✅ No console errors (F12 Developer Tools)

**Test:**
- Sign in functionality
- Create a story
- Record audio
- Upload to memory bank

### 3. Verify Navigation

**Test the flow:**
1. Start at `yourdomain.com/`
2. Click "Get Started"
3. Should navigate to `yourdomain.com/app`
4. App should load

### 4. Check Browser Console

Open Developer Tools (F12) and check:
- **No 404 errors** for assets
- **No CORS errors**
- **No missing files**

Common issues:
- `Failed to load resource: 404` → File not uploaded or wrong path
- `CORS policy` → Backend configuration issue
- `flutter.js not found` → `/app/` folder structure incorrect

---

## Troubleshooting

### Issue: Flutter App Shows Blank White Screen

**Causes:**
- Incorrect `--base-href` during build
- Files not uploaded correctly
- Browser caching old version

**Solutions:**
1. Rebuild with correct base-href:
   ```bash
   flutter build web --release --base-href "/app/"
   ```
2. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
3. Check browser console for errors (F12)
4. Verify `/app/index.html` exists on server

### Issue: 404 Error for main.dart.js

**Cause:** Folder structure incorrect

**Solution:**
- Verify `deploy/app/main.dart.js` exists locally
- Re-upload the entire `app/` folder
- Check that `app/` is a subdirectory, not merged with root

### Issue: Landing Page Loads but "Get Started" Button Doesn't Work

**Cause:** `/app/` directory missing or incorrect

**Solution:**
- Verify `public_html/app/` exists on server
- Check link in `index.html` points to `/app` (line 89, 111, 148)

### Issue: Images Don't Load on Landing Page

**Cause:** Assets folder not uploaded

**Solution:**
- Upload `assets/` folder to root
- Verify `public_html/assets/` contains all images
- Check image paths in `index.html` (e.g., `assets/hero_transformation_v5.png`)

### Issue: Build Takes Forever or Fails

**Causes:**
- Slow internet (downloading packages)
- Outdated dependencies
- Insufficient disk space

**Solutions:**
1. Run `flutter pub get` first
2. Clear build cache: `flutter clean`
3. Update Flutter: `flutter upgrade`
4. Check disk space: `df -h`

### Issue: Wasm Warnings During Build

**Example:**
```
Wasm dry run findings:
Found incompatibilities with WebAssembly.
```

**Solution:**
- These are warnings, not errors
- Your app still builds successfully
- Ignore unless you specifically need WebAssembly
- To disable warnings: `flutter build web --release --no-wasm-dry-run`

---

## Automated Deployment Script

For convenience, create a deployment script that automates the entire process.

### Create `deploy.sh`

```bash
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
```

### Make Script Executable

```bash
chmod +x deploy.sh
```

### Run the Script

```bash
./deploy.sh
```

**Output:**
```
🚀 Building PARfolio for Hostinger deployment...

🧹 Cleaning previous build...
📄 Copying landing page files...
   ✓ Landing page files copied

🔨 Building Flutter web app...
   ✓ Flutter app built successfully

📦 Packaging Flutter app...
   ✓ Flutter app packaged

✅ Build complete!

📊 Deployment Summary:
   Location: ./deploy/
   Size: 40M

📤 Next Steps:
   1. Log into Hostinger File Manager
   2. Navigate to public_html/
   3. Upload all contents from ./deploy/

🌐 After upload, test:
   - Landing page: https://yourdomain.com/
   - Flutter app:  https://yourdomain.com/app
```

---

## Additional Build Options

### Build Without Base Href (Root Deployment)

If deploying Flutter app to root instead of `/app/`:

```bash
flutter build web --release
```

### Build with Higher Optimization

```bash
flutter build web --release -O=4
```

### Build Without PWA Service Worker

Disable offline caching:

```bash
flutter build web --release --pwa-strategy=none
```

### Build Without CDN Resources

Host all resources yourself:

```bash
flutter build web --release --no-web-resources-cdn
```

---

## Version Control

The `deploy/` folder is automatically ignored by git (see `.gitignore`).

**Why?**
- Contains build artifacts (40 MB)
- Can be regenerated from source
- Prevents repo bloat
- Avoids merge conflicts

**Git Ignore Entry:**
```
# Build/Deploy artifacts
deploy/
```

---

## Deployment Checklist

Before deploying to production:

- [ ] Run `flutter build web --release --base-href "/app/"`
- [ ] Verify `deploy/` folder is ~40 MB
- [ ] Check `deploy/index.html` exists (landing page)
- [ ] Check `deploy/app/index.html` exists (Flutter app)
- [ ] Test locally with `python3 -m http.server 8000` in `deploy/`
- [ ] Upload all files to Hostinger `public_html/`
- [ ] Test landing page loads at `yourdomain.com/`
- [ ] Test Flutter app loads at `yourdomain.com/app`
- [ ] Check mobile responsiveness
- [ ] Verify no console errors (F12)
- [ ] Test all navigation links work
- [ ] Clear browser cache and test again

---

## Performance Optimization Tips

### 1. Enable Gzip Compression on Hostinger

Add to `.htaccess` in `public_html/`:

```apache
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/css text/javascript
  AddOutputFilterByType DEFLATE application/javascript application/json
  AddOutputFilterByType DEFLATE image/svg+xml
</IfModule>
```

### 2. Enable Browser Caching

```apache
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType text/css "access plus 1 year"
  ExpiresByType application/javascript "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>
```

### 3. Enable HTTPS

- Use Hostinger's free SSL certificate
- Forces secure connections
- Required for PWA features

---

## Future Improvements

### CI/CD Automation

Consider setting up automated deployments:
- **GitHub Actions** - Build on commit, deploy automatically
- **Hostinger Git** - Pull and build from repository
- **FTP Deployment** - Script-based uploads

### Backend Integration

If deploying backend separately:
- Update Flutter app's API endpoints
- Configure CORS on backend
- Use environment variables for API URLs

---

## Support

For issues:
1. Check [Troubleshooting](#troubleshooting) section
2. Review browser console (F12) for errors
3. Verify file structure matches [Deployment Structure](#deployment-structure)
4. Test locally before uploading

---

**Last Updated:** January 22, 2026
**Maintained By:** PARfolio Development Team
