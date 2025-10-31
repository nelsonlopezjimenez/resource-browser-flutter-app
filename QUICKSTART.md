# Quick Start Guide

Get your Resource Browser running in 5 minutes!

## Step 1: Install Dependencies

Open your terminal in the project folder and run:

```bash
flutter pub get
```

This downloads all the required packages.

## Step 2: Add Your Resources

1. Create a folder in `web/` called `resources`:
   ```
   web/resources/
   ```

2. Add some sample files:
   - `video.mp4` - any video file
   - `document.pdf` - any PDF
   - `notes.md` - a markdown file
   - `page.mhtml` - an MHTML file (optional)

## Step 3: Update the Manifest

Edit `web/resources_manifest.txt`:

```
resources/video.mp4
resources/document.pdf
resources/notes.md
resources/page.mhtml
```

**Important**: List only files that actually exist!

## Step 4: Run the App

```bash
flutter run -d chrome
```

The app will open in Chrome and you'll see your resources!

## What You Should See

- **Left sidebar**: Grid of your resource files
- **Right area**: "Select a resource to view" message
- **Click any card**: View the file content

## Testing Tips

### Create a Sample Markdown File

Create `web/resources/test.md` with this content:

```markdown
# Welcome to Resource Browser!

This is a **test** markdown file.

## Features
- Videos
- PDFs
- Markdown
- MHTML

Pretty cool, right?
```

Add it to your manifest:
```
resources/test.md
```

### Troubleshooting

**Problem**: "No resources found"
- **Solution**: Check that `resources_manifest.txt` exists and has correct paths

**Problem**: File won't load
- **Solution**: Verify the file path matches exactly what's in the manifest

**Problem**: Flutter command not found
- **Solution**: Make sure Flutter is in your PATH (restart terminal after installation)

## Next Steps

Once it's working:

1. Add more of your own files
2. Try different file types
3. Explore the code (heavily commented!)
4. Read the full README.md
5. Start customizing!

## Need Help?

- Check the main README.md for detailed documentation
- Review the code comments
- All the code is designed to be beginner-friendly!

---

**You're all set! Enjoy browsing your resources! 🎉**
