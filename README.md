# Resource Browser

A Flutter web application for browsing and viewing different types of resources including videos, PDFs, markdown files, and MHTML files.

## Features

- 📁 Browse resources from a public folder
- 🎥 Play video files (MP4, WebM, OGG)
- 📄 View PDF documents
- 📝 Read formatted Markdown files
- 🌐 Display MHTML web archives
- 🔄 Refresh to scan for new files
- 💻 Professional, clean interface
- 📱 Responsive design

## Project Structure

```
resource_browser/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── resource_item.dart       # Data model for resources
│   ├── services/
│   │   └── file_scanner.dart        # Service to scan for files
│   ├── screens/
│   │   └── home_screen.dart         # Main application screen
│   └── widgets/
│       ├── resource_list.dart       # Grid display of resources
│       └── resource_viewer.dart     # Viewers for each file type
├── web/
│   ├── index.html                   # Web entry point
│   ├── manifest.json                # Web app manifest
│   └── resources_manifest.txt       # List of available resources
└── pubspec.yaml                     # Dependencies and configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- A web browser (Chrome, Edge, Firefox, etc.)

### Installation

1. **Clone or download this project**

2. **Navigate to the project directory**
   ```bash
   cd resource_browser
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Set up your resources**
   
   Create a folder for your resources (e.g., `web/resources/`) and place your files there:
   ```
   web/
   ├── resources/
   │   ├── video1.mp4
   │   ├── guide.pdf
   │   ├── readme.md
   │   └── page.mhtml
   └── resources_manifest.txt
   ```

5. **Update the manifest file**
   
   Edit `web/resources_manifest.txt` and list all your resource files:
   ```
   resources/video1.mp4
   resources/guide.pdf
   resources/readme.md
   resources/page.mhtml
   ```

6. **Run the application**
   ```bash
   flutter run -d chrome
   ```
   
   Or for other browsers:
   ```bash
   flutter run -d edge
   flutter run -d firefox
   ```

## How It Works

### File Scanning

The app uses a simple manifest-based approach:

1. You create a text file (`resources_manifest.txt`) listing all your resources
2. The app reads this manifest when it starts
3. Each file is categorized by its extension
4. Files appear in the sidebar for selection

This approach is simple and works well for beginners. In future iterations, this can be enhanced with automatic server-side scanning.

### File Type Support

| Type | Extensions | Description |
|------|------------|-------------|
| Video | .mp4, .webm, .ogg | Video player with controls |
| PDF | .pdf | Full PDF viewer with zoom/scroll |
| Markdown | .md, .markdown | Rendered markdown with formatting |
| MHTML | .mhtml, .mht | Web archive display |

### Code Organization

The code is organized into logical folders:

- **models/**: Data structures (ResourceItem)
- **services/**: Business logic (FileScanner)
- **screens/**: Full-page views (HomeScreen)
- **widgets/**: Reusable UI components (ResourceList, ResourceViewer)

This structure makes it easy to find and modify specific parts of the app.

## Customization

### Changing Colors

Edit `lib/main.dart` to change the app theme:

```dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // Change this to your preferred color
  useMaterial3: true,
),
```

### Adding New File Types

To support additional file types:

1. Update `ResourceItem.fromPath()` in `lib/models/resource_item.dart`
2. Add a new viewer widget in `lib/widgets/resource_viewer.dart`
3. Update the switch statement to use your new viewer

### Modifying the Layout

- **Sidebar width**: Change the `width` property in `home_screen.dart` (currently 300)
- **Grid columns**: Modify `crossAxisCount` in `resource_list.dart`
- **Card size**: Adjust `childAspectRatio` in `resource_list.dart`

## Deployment

### Building for Production

```bash
flutter build web
```

This creates an optimized build in the `build/web` directory.

### Hosting

You can host the built app on any static web server:

- **GitHub Pages**: Push the `build/web` folder
- **Firebase Hosting**: Use `firebase deploy`
- **Netlify**: Drag and drop the `build/web` folder
- **Your own server**: Copy files to your web root

**Important**: Make sure your resource files are accessible from the deployed location!

## Future Enhancements

This is a simple first iteration. Here are ideas for future versions:

### Planned Features

- ✅ Basic file browsing (DONE)
- ✅ Multiple file type viewers (DONE)
- 🔜 Search functionality
- 🔜 Sort by name, date, type
- 🔜 Automatic file scanning (no manifest needed)
- 🔜 Folder navigation
- 🔜 File filtering
- 🔜 Bookmarks/favorites
- 🔜 Better MHTML rendering
- 🔜 Image support
- 🔜 Audio support
- 🔜 Dark mode

### Code Improvements for Later

- State management (Provider, Riverpod, or Bloc)
- Better error handling
- Loading states
- Caching
- Virtual scrolling for large lists
- Better responsive design for mobile

## Troubleshooting

### "No resources found"

- Check that `resources_manifest.txt` exists in the `web/` folder
- Verify the file paths in the manifest are correct
- Make sure the resource files actually exist

### Video won't play

- Ensure the video format is supported (MP4, WebM, OGG)
- Check that the file path is accessible
- Try using a different video codec

### PDF won't load

- Verify the PDF file is not corrupted
- Check the file path in the manifest
- Ensure the PDF is accessible from your web server

### App is slow

- Reduce the number of resources in the manifest
- Optimize your resource files (compress videos/PDFs)
- Consider implementing pagination in future versions

## Comments in the Code

The code is heavily commented to help beginners understand:

- **What** each part does
- **Why** it's designed that way
- **How** to modify it

Look for comments like:
```dart
/// This is a documentation comment
// This is a regular comment explaining the code
```

## Learning Resources

If you're new to Flutter, here are some helpful resources:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)

## License

This is a sample project for learning purposes. Feel free to use and modify as needed.

## Contributing

This is a beginner-friendly project. Improvements welcome!

---

**Happy coding! 🚀**
