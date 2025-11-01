# Express Server Configuration

## Problem: New Resources Not Showing Up

When you add resources to your manifest file after building, they don't appear because the manifest is cached by the browser.

## Solution 1: Client-Side Cache Busting (Already Implemented)

The Flutter app now adds a timestamp to manifest requests:
```
/resources_manifest.txt?t=1234567890
```

This forces the browser to fetch a fresh copy every time you click the refresh button.

## Solution 2: Server-Side Cache Headers (Recommended)

Update your Express server to prevent manifest caching:

### Basic Express Setup

```javascript
const express = require('express');
const path = require('path');
const app = express();

// Serve your Flutter build
app.use(express.static('build/web'));

// Special handling for manifest file - NO CACHING
app.get('/resources_manifest.txt', (req, res) => {
  res.set({
    'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
    'Surrogate-Control': 'no-store'
  });
  res.sendFile(path.join(__dirname, 'build/web/resources_manifest.txt'));
});

// Serve resources with caching (they don't change)
app.use('/resources', express.static('build/web/resources', {
  maxAge: '1d' // Cache resources for 1 day
}));

app.listen(22028, () => {
  console.log('Server running on http://localhost:22028');
});
```

### Complete Example with CORS

```javascript
const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();

// Enable CORS for all routes
app.use(cors());

// Logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// NO CACHE for manifest file
app.get('/resources_manifest.txt', (req, res) => {
  console.log('Serving fresh manifest file');
  res.set({
    'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0'
  });
  res.sendFile(path.join(__dirname, 'build/web/resources_manifest.txt'));
});

// Cache resources (they rarely change)
app.use('/resources', express.static('build/web/resources', {
  maxAge: '1h', // Cache for 1 hour
  setHeaders: (res, path) => {
    console.log(`Serving resource: ${path}`);
  }
}));

// Serve Flutter app (normal caching for app files)
app.use(express.static('build/web', {
  maxAge: '1h'
}));

// Fallback to index.html for Flutter routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

const PORT = process.env.PORT || 22028;
app.listen(PORT, () => {
  console.log(`\n🚀 Server running on http://localhost:${PORT}`);
  console.log(`📁 Serving from: ${path.join(__dirname, 'build/web')}`);
  console.log(`\n✅ Manifest: NO caching`);
  console.log(`✅ Resources: 1 hour cache`);
  console.log(`✅ App files: 1 hour cache\n`);
});
```

## Your Current Manifest Format

Based on your paths, here's the correct format:

```
# Local resources (relative paths work)
/resources/what_is_a_browser.mp4
/resources/Web_Graphics_Basics.pdf
/resources/week1.md
/resources/git-lfs-usage.md
/resources/about_READMEs.mhtml
/resources/flutter-build-vs-dev.md
/resources/flutter-hybrid-dev-build.md

# GitHub raw content URLs
https://raw.githubusercontent.com/nelsonlopezjimenez/class-server-resources/main/markdown/lessons/section1-html-css/week2.md

# Other localhost resources (if you have another server)
http://localhost:22028/week2.md
http://localhost:22028/lessons/week2.md
http://localhost:22028/lessons/week3.md
```

**Important Notes:**
1. Use `/resources/` (with leading slash) for files served by your Express server
2. Use full URLs for GitHub or external resources
3. Make sure GitHub URLs are raw content URLs, not the GitHub page URLs

## Testing Your Setup

### 1. Verify Manifest is Accessible

```bash
# Should return your manifest content without caching
curl -I http://localhost:22028/resources_manifest.txt

# Check for these headers:
# Cache-Control: no-store, no-cache...
# Pragma: no-cache
```

### 2. Verify Resources are Accessible

```bash
# Test each resource
curl -I http://localhost:22028/resources/week1.md
curl -I http://localhost:22028/resources/Web_Graphics_Basics.pdf

# Should return 200 OK
```

### 3. Test GitHub URLs

```bash
# Make sure GitHub URLs work
curl -I https://raw.githubusercontent.com/nelsonlopezjimenez/class-server-resources/main/markdown/lessons/section1-html-css/week2.md

# Should return 200 OK
```

## Workflow for Adding New Resources

### Option 1: Files on Your Server

```bash
# 1. Add file to build/web/resources/
cp newfile.pdf build/web/resources/

# 2. Update manifest (build/web/resources_manifest.txt)
echo "/resources/newfile.pdf" >> build/web/resources_manifest.txt

# 3. In your Flutter app, click the Refresh button (or press Ctrl+Shift+R)
# Done! No rebuild needed!
```

### Option 2: Files on GitHub

```bash
# 1. Push file to GitHub repo

# 2. Get raw URL (click "Raw" button on GitHub)
# Example: https://raw.githubusercontent.com/user/repo/main/file.md

# 3. Add to manifest
echo "https://raw.githubusercontent.com/.../file.md" >> build/web/resources_manifest.txt

# 4. Click Refresh in app
```

## Common Issues

### Issue: "Resource not showing up"

**Check:**
1. Is the file path correct in the manifest?
2. Is the file actually at that location on the server?
3. Did you click the Refresh button in the app?
4. Check browser console (F12) for 404 errors

**Test:**
```bash
# Try accessing the resource directly in browser
http://localhost:22028/resources/yourfile.pdf
```

### Issue: "404 Not Found"

**Causes:**
- File doesn't exist at that path
- Path typo in manifest
- Server not serving the resources folder

**Fix:**
```bash
# Verify file exists
ls build/web/resources/

# Check server is serving resources
curl http://localhost:22028/resources/yourfile.pdf
```

### Issue: "CORS error" for GitHub URLs

**Cause:**
Using GitHub page URL instead of raw content URL

**Wrong:**
```
https://github.com/user/repo/blob/main/file.md
```

**Correct:**
```
https://raw.githubusercontent.com/user/repo/main/file.md
```

### Issue: "Still showing old manifest"

**Solutions:**
1. Click Refresh button in app
2. Hard refresh browser (Ctrl+Shift+R)
3. Clear browser cache
4. Check server logs to verify manifest is being served fresh

## Server Deployment Checklist

When deploying to production:

- [ ] Copy resources to server: `build/web/resources/`
- [ ] Copy manifest to server: `build/web/resources_manifest.txt`
- [ ] Configure Express with no-cache headers for manifest
- [ ] Test all resource URLs are accessible
- [ ] Test GitHub URLs work from server
- [ ] Verify refresh button loads new items

## Pro Tips

### 1. Separate Resources by Type

```
/resources/videos/what_is_a_browser.mp4
/resources/pdfs/Web_Graphics_Basics.pdf
/resources/markdown/week1.md
```

### 2. Use Versioning

```
/resources/v1/document.pdf
/resources/v2/document.pdf
```

Prevents cache issues when updating files.

### 3. Monitor Server Logs

Your logs will show:
- Which resources are being requested
- 404 errors for missing files
- Manifest requests

### 4. Automate Deployment

```bash
# deploy.sh
flutter build web
cp -r build/web/* /var/www/html/
cp resources_manifest.txt /var/www/html/
systemctl restart nginx
```

## Summary

✅ **Client-side:** App adds timestamps to manifest requests (implemented)
✅ **Server-side:** Configure Express with no-cache headers (you need to add this)
✅ **Workflow:** Add file → Update manifest → Click refresh
✅ **No rebuild:** Just update files on server and refresh app

With these changes, adding new resources is as simple as:
1. Add file to server
2. Update manifest
3. Click refresh button

No Flutter rebuild needed! 🚀