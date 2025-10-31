# Git Setup Guide

## What's Included

✅ **.gitignore** - Tells git which files to ignore
✅ **web/resources/.gitkeep** - Tracks the folder structure but not your resource files

## Initial Git Setup

You've already run `git init`. Here's what to do next:

### 1. Check Git Status

```bash
git status
```

You should see all your project files ready to be committed.

### 2. Add All Files

```bash
git add .
```

This stages all files for commit (except those in .gitignore).

### 3. Create Initial Commit

```bash
git commit -m "Initial commit: Resource Browser Flutter app"
```

### 4. (Optional) Create a GitHub Repository

If you want to push to GitHub:

```bash
# Create a repo on GitHub first, then:
git remote add origin https://github.com/yourusername/resource-browser.git
git branch -M main
git push -u origin main
```

## What Gets Tracked vs Ignored

### ✅ Tracked (Goes into Git)

- All source code (`.dart` files)
- Configuration files (`pubspec.yaml`, `analysis_options.yaml`)
- Documentation (`.md` files)
- Web configuration (`index.html`, `manifest.json`)
- Resource manifest (`resources_manifest.txt`)
- Folder structure (`web/resources/.gitkeep`)

### ❌ Ignored (Stays Local)

- Build outputs (`/build/`)
- Dependencies (`.dart_tool/`, `.packages`)
- IDE settings (`.vscode/`, `.idea/`)
- Your actual resource files (`web/resources/*` except `.gitkeep`)
- Generated files
- OS-specific files (`.DS_Store`, `Thumbs.db`)

## Why Ignore Resource Files?

Your videos, PDFs, and other media files are typically:
- 🔴 Too large for Git (videos can be 100s of MB)
- 🔴 Binary files (Git handles text better)
- 🔴 User-specific content
- 🔴 May contain sensitive information

Instead, you should:
- ✅ Keep them local in `web/resources/`
- ✅ Document what files are needed (in README)
- ✅ Use a separate storage solution (cloud storage, CDN)

## Useful Git Commands

### Check Status
```bash
git status
```

### See What's Changed
```bash
git diff
```

### Add Specific Files
```bash
git add lib/main.dart
git add lib/widgets/
```

### Commit Changes
```bash
git commit -m "Add search functionality"
```

### View Commit History
```bash
git log
git log --oneline  # Compact view
```

### Create a Branch
```bash
git checkout -b feature/add-search
```

### Switch Branches
```bash
git checkout main
```

### Merge Branch
```bash
git checkout main
git merge feature/add-search
```

### Push to Remote
```bash
git push origin main
```

### Pull from Remote
```bash
git pull origin main
```

## Recommended Commit Messages

Use clear, descriptive commit messages:

### Good Examples ✅
```
Initial commit: Resource Browser Flutter app
Add search functionality to resource list
Fix overflow issue in resource cards
Update README with deployment instructions
Refactor file scanner service
Add PDF viewer functionality
```

### Bad Examples ❌
```
Update
Fix
Changes
WIP
asdf
```

## .gitignore Explained

### Flutter/Dart Specific
```
.dart_tool/         # Dart tool cache
.packages           # Package dependencies
.pub/               # Pub cache
/build/             # Build output
```

### IDE Files
```
.vscode/            # VS Code settings
.idea/              # IntelliJ/Android Studio
*.iml               # IntelliJ module files
```

### Generated Files
```
*.g.dart            # Generated code
*.freezed.dart      # Freezed generated
```

### Your Resources
```
web/resources/      # Your media files
!web/resources/.gitkeep  # Except this marker file
```

### OS Files
```
.DS_Store           # macOS
Thumbs.db           # Windows
```

## Managing Resource Files

### Option 1: Document in README
```markdown
## Required Resources
Place the following files in `web/resources/`:
- sample-video.mp4
- user-guide.pdf
- readme.md
```

### Option 2: Use a Sample Manifest
Include a `resources_manifest.example.txt`:
```
# Copy this to resources_manifest.txt and update paths
resources/your-video.mp4
resources/your-pdf.pdf
```

### Option 3: Cloud Storage
For production:
- Upload resources to AWS S3, Google Cloud Storage, etc.
- Update manifest to use full URLs
- Update `.gitignore` if using environment variables

## Git Workflow Suggestions

### For Solo Development
```bash
# Work on main branch
git add .
git commit -m "Descriptive message"
git push
```

### For Team Development
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
git add .
git commit -m "Add new feature"

# Push branch
git push origin feature/new-feature

# Create Pull Request on GitHub
# After review and merge, update local:
git checkout main
git pull origin main
```

## Troubleshooting

### "Please tell me who you are"
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Accidentally Committed Large Files
```bash
# Remove from git but keep locally
git rm --cached web/resources/large-video.mp4
git commit -m "Remove large file from git"
```

### Want to Track Resource Files Anyway
Edit `.gitignore` and remove or comment out:
```
# web/resources/
# !web/resources/.gitkeep
```

**Note**: Only do this for small files or demos!

### Reset to Last Commit
```bash
# Discard all local changes
git reset --hard HEAD

# Discard changes to specific file
git checkout -- lib/main.dart
```

## GitHub Repository Setup

### 1. Create Repository on GitHub
- Go to github.com
- Click "New repository"
- Name it (e.g., "resource-browser")
- Don't initialize with README (you already have one)

### 2. Connect Local to GitHub
```bash
git remote add origin https://github.com/yourusername/resource-browser.git
git branch -M main
git push -u origin main
```

### 3. Verify
Visit your GitHub repository URL - you should see all your files!

## Best Practices

### ✅ Do:
- Commit often with clear messages
- Pull before pushing (if team project)
- Use branches for new features
- Keep commits focused (one feature/fix per commit)
- Review changes before committing (`git diff`)

### ❌ Don't:
- Commit sensitive data (API keys, passwords)
- Commit large binary files (videos, etc.)
- Use vague commit messages
- Commit broken code to main branch
- Force push (`git push -f`) without good reason

## .gitignore Customization

If you want to track additional files or ignore others, edit `.gitignore`:

### Example: Track VS Code Settings
```
.vscode/*
!.vscode/settings.json    # Track this file
!.vscode/tasks.json       # And this one
```

### Example: Ignore Specific Files
```
# Ignore all .log files
*.log

# Except important.log
!important.log
```

## Quick Reference

```bash
# Status
git status

# Stage changes
git add .
git add <file>

# Commit
git commit -m "Message"

# Push
git push

# Pull
git pull

# Branch
git branch                    # List branches
git checkout -b new-branch   # Create and switch
git checkout main            # Switch to main

# View changes
git diff                     # Unstaged changes
git diff --staged           # Staged changes
git log                      # Commit history

# Undo
git checkout -- <file>      # Discard changes
git reset HEAD <file>       # Unstage file
git reset --hard HEAD       # Reset everything
```

---

## Your Next Steps

1. ✅ You've already run `git init`
2. ✅ You have `.gitignore` configured
3. 📝 Add all files: `git add .`
4. 📝 First commit: `git commit -m "Initial commit: Resource Browser"`
5. 📝 (Optional) Push to GitHub

**Your project is now Git-ready!** 🎉
