# Setup Checklist ✅

Use this checklist to get your Resource Browser up and running!

## Pre-Flight Check

- [ ] Flutter is installed (`flutter --version` works)
- [ ] You can run `flutter doctor` (minor warnings are okay)
- [ ] You have a web browser (Chrome or Edge recommended)
- [ ] You have this project folder ready

## Initial Setup (Do Once)

### 1. Install Dependencies
```bash
cd resource_browser
flutter pub get
```
- [ ] Command completed successfully
- [ ] No major errors (warnings are okay)

### 2. Create Resource Folder
```bash
mkdir web/resources
```
Or manually create: `web/resources/`

- [ ] Folder created
- [ ] You can see it in your file explorer

### 3. Add Sample Files

Choose at least one option:

**Option A: Quick Test**
- [ ] Create `web/resources/test.md` with some markdown content
- [ ] Add `resources/test.md` to manifest

**Option B: Full Test**
- [ ] Add a video file (MP4) to `web/resources/`
- [ ] Add a PDF file to `web/resources/`
- [ ] Add a markdown file to `web/resources/`
- [ ] (Optional) Add an MHTML file

### 4. Update Manifest

Edit `web/resources_manifest.txt`:

- [ ] Open the file
- [ ] Remove the example/comment lines (or leave them)
- [ ] Add your actual file paths (one per line)
- [ ] Save the file

Example:
```
resources/test.md
resources/video.mp4
resources/document.pdf
```

### 5. First Run

```bash
flutter run -d chrome
```

- [ ] Command starts without errors
- [ ] Browser opens automatically
- [ ] App interface appears

## Verification Checks

### Visual Check
- [ ] You see "Resource Browser" in the title bar
- [ ] Left sidebar shows "Resources" header
- [ ] Resource count badge shows correct number
- [ ] Your resource cards appear in the grid
- [ ] Each card shows the correct icon and file name

### Functional Check
- [ ] Click a resource card
- [ ] Content area updates
- [ ] You see the file name at the top
- [ ] The file content displays correctly
- [ ] Click the back arrow
- [ ] Returns to "Select a resource" screen
- [ ] Click refresh button
- [ ] Resources reload

### Type-Specific Checks

**If you added a video:**
- [ ] Video player appears
- [ ] Play button works
- [ ] Video plays
- [ ] Progress bar works
- [ ] Pause button works

**If you added a PDF:**
- [ ] PDF renders
- [ ] You can scroll through pages
- [ ] Zoom controls work

**If you added markdown:**
- [ ] Text is formatted (headings, bold, etc.)
- [ ] Lists render correctly
- [ ] You can select text

**If you added MHTML:**
- [ ] Content appears (even if raw)
- [ ] You can scroll

## Troubleshooting Checklist

### Problem: "No resources found"

Check:
- [ ] `web/resources_manifest.txt` file exists
- [ ] Manifest file is not empty
- [ ] File paths in manifest are correct
- [ ] File paths match actual files
- [ ] No typos in file names

Fix:
```bash
# Verify files exist
ls web/resources/

# Check manifest content
cat web/resources_manifest.txt
```

### Problem: "flutter: not found"

Check:
- [ ] Flutter is installed
- [ ] Flutter is in your PATH
- [ ] Terminal/command prompt is restarted

Fix:
```bash
# Add to PATH (example for Windows)
# Add C:\Users\YourName\flutter\bin to PATH

# Verify
flutter doctor
```

### Problem: File won't load/display

Check:
- [ ] File path is correct in manifest
- [ ] File is not corrupted
- [ ] File format is supported
- [ ] Browser console for errors (F12)

Fix:
- Try with a different file
- Check browser console
- Verify file path exactly matches

### Problem: Port already in use

Fix:
```bash
# Try a different port
flutter run -d chrome --web-port=8081
```

### Problem: Hot reload not working

Fix:
- [ ] Stop the app (Ctrl+C)
- [ ] Run `flutter run -d chrome` again
- [ ] Or press 'r' in terminal for hot reload
- [ ] Or press 'R' for hot restart

## Customization Checklist (Optional)

Once it's working, try these customizations:

### Easy Customizations
- [ ] Change app title in `lib/main.dart`
- [ ] Change primary color
- [ ] Adjust sidebar width
- [ ] Modify card spacing

### Medium Customizations
- [ ] Add more file types
- [ ] Change grid layout (3 columns?)
- [ ] Add custom icons
- [ ] Modify color scheme

### Advanced (Future)
- [ ] Add search functionality
- [ ] Implement sorting
- [ ] Add folder navigation
- [ ] Create dark theme

## Documentation Checklist

Have you read:
- [ ] **PROJECT_SUMMARY.md** - Overview and features
- [ ] **QUICKSTART.md** - Setup guide
- [ ] **README.md** - Full documentation
- [ ] **VISUAL_GUIDE.md** - UI layout explanation
- [ ] **DEVELOPMENT.md** - Architecture and enhancements

## Code Exploration Checklist

Have you looked at:
- [ ] `lib/main.dart` - Entry point
- [ ] `lib/screens/home_screen.dart` - Main screen logic
- [ ] `lib/models/resource_item.dart` - Data model
- [ ] `lib/services/file_scanner.dart` - File scanning
- [ ] `lib/widgets/resource_list.dart` - Grid display
- [ ] `lib/widgets/resource_viewer.dart` - File viewers

Each file is heavily commented - read through them!

## Production Checklist (When Ready)

- [ ] Test with real files
- [ ] Test with many files (50+)
- [ ] Test video playback
- [ ] Test PDF rendering
- [ ] Test on different browsers
- [ ] Test on different screen sizes
- [ ] Build for production: `flutter build web`
- [ ] Deploy to hosting service
- [ ] Test deployed version
- [ ] Update manifest on server
- [ ] Verify all files are accessible

## Learning Checklist

As you learn Flutter:
- [ ] Understand widget composition
- [ ] Learn about StatefulWidget vs StatelessWidget
- [ ] Understand setState
- [ ] Learn about async/await
- [ ] Explore Flutter widgets
- [ ] Read Flutter documentation
- [ ] Try modifying existing code
- [ ] Add a new feature

## Success Criteria

You're successful when:
- [x] App runs without errors
- [x] You can see your resources
- [x] You can click and view files
- [x] You understand the basic structure
- [x] You can make simple modifications

## Next Steps

- [ ] **Today**: Get it running with sample files
- [ ] **This Week**: Add your real resources
- [ ] **Next Week**: Customize the appearance
- [ ] **This Month**: Add a new feature (search?)
- [ ] **Next Month**: Implement advanced features

## Quick Command Reference

```bash
# Install dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Run in Edge
flutter run -d edge

# Build for production
flutter build web

# Check Flutter setup
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome

# Hot reload (when app is running)
Press 'r' in terminal

# Hot restart (when app is running)
Press 'R' in terminal

# Quit
Press 'q' in terminal or Ctrl+C
```

## File Path Reference

```
Important Files:
- lib/main.dart              - Start here
- web/resources_manifest.txt - Your file list
- web/resources/             - Your files here
- pubspec.yaml               - Dependencies

Documentation:
- PROJECT_SUMMARY.md         - Start here
- QUICKSTART.md              - Quick setup
- README.md                  - Full guide
- VISUAL_GUIDE.md            - UI layout
- DEVELOPMENT.md             - Advanced

Configuration:
- analysis_options.yaml      - Code rules
- web/index.html             - Web entry
- web/manifest.json          - Web config
```

## Support Resources

- 📚 **Project Docs**: Read the .md files
- 💬 **Code Comments**: Every file is commented
- 🌐 **Flutter Docs**: https://docs.flutter.dev
- 🎓 **Flutter Codelabs**: https://docs.flutter.dev/codelabs

---

## Final Check

Before asking for help, verify:
- [ ] Ran `flutter pub get`
- [ ] Files exist in `web/resources/`
- [ ] Manifest file is correct
- [ ] Tried restarting the app
- [ ] Checked browser console (F12)
- [ ] Read relevant documentation

---

**Ready to go? Start with the Pre-Flight Check at the top!**

**Good luck! 🚀**

---

**Pro Tip**: Keep this checklist handy. Come back to it whenever you:
- Set up on a new machine
- Help someone else get started
- Debug issues
- Need a quick reference
