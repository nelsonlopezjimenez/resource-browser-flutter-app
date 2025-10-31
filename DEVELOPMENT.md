# Development Guide

This guide explains how the app works and how to extend it for future iterations.

## Architecture Overview

### Current Design (Simple & Beginner-Friendly)

```
┌─────────────────────────────────────────────────┐
│                   main.dart                     │
│              (App Configuration)                │
└──────────────────┬──────────────────────────────┘
                   │
        ┌──────────▼──────────┐
        │   HomeScreen        │
        │  (Main Layout)      │
        └──────┬────────┬─────┘
               │        │
     ┌─────────▼─┐   ┌─▼──────────────┐
     │ Resource  │   │ Resource       │
     │ List      │   │ Viewer         │
     │ (Sidebar) │   │ (Content Area) │
     └─────┬─────┘   └─────┬──────────┘
           │               │
     ┌─────▼─────┐   ┌─────▼──────┐
     │ File      │   │ Type-      │
     │ Scanner   │   │ Specific   │
     │           │   │ Viewers    │
     └───────────┘   └────────────┘
```

## Key Components Explained

### 1. Models (`lib/models/`)

**Purpose**: Define data structures

**Current File**: `resource_item.dart`
- Represents a single file
- Stores: name, type, path, extension
- Factory method to create from path
- Simple and focused

**Future Additions**:
```dart
// FileMetadata - for dates, sizes, etc.
class FileMetadata {
  final DateTime lastModified;
  final int fileSize;
  final String mimeType;
}

// FolderItem - for folder navigation
class FolderItem {
  final String name;
  final String path;
  final List<ResourceItem> children;
}
```

### 2. Services (`lib/services/`)

**Purpose**: Handle business logic and data operations

**Current File**: `file_scanner.dart`
- Reads manifest file
- Creates ResourceItem objects
- Returns list of resources

**How It Works**:
```dart
1. Fetch resources_manifest.txt
2. Parse each line
3. Skip comments and empty lines
4. Create ResourceItem for each valid path
5. Return list
```

**Future Enhancements**:
```dart
// Auto-scanning (no manifest needed)
class AutoFileScanner {
  // Scan server directory structure
  // Use server-side script or API
  Future<List<ResourceItem>> autoScan(String directory);
}

// Caching service
class CacheService {
  // Cache file list
  // Reduce server requests
  // Improve performance
}

// Search service
class SearchService {
  // Filter by name
  // Filter by type
  // Full-text search (for text files)
}
```

### 3. Screens (`lib/screens/`)

**Purpose**: Full-page views

**Current File**: `home_screen.dart`
- Main application screen
- Two-column layout
- Manages state (selected resource, loading)
- Coordinates between list and viewer

**State Management**:
```dart
// Current: setState (simple, built-in)
_resources        // List of all resources
_selectedResource // Currently viewing
_isLoading        // Loading state

// Future: Provider, Riverpod, or Bloc
// Better for complex state
// Easier to test
// More scalable
```

**Future Screens**:
```dart
// SearchScreen - dedicated search interface
// SettingsScreen - user preferences
// FolderNavigationScreen - browse folders
```

### 4. Widgets (`lib/widgets/`)

**Purpose**: Reusable UI components

**Current Files**:

#### `resource_list.dart`
- Grid display of resources
- Resource cards with hover effects
- Click handling
- Empty state message

**Customization Points**:
```dart
// Change grid layout
crossAxisCount: 2        // Number of columns
childAspectRatio: 1.5   // Card proportions
crossAxisSpacing: 16    // Horizontal spacing
mainAxisSpacing: 16     // Vertical spacing

// Change card appearance
elevation: 2            // Shadow depth
color: Colors.blue      // Accent color
```

#### `resource_viewer.dart`
- Switches between different viewers
- Type-specific rendering
- Loading and error states

**Viewer Types**:
- `VideoViewer` - Video player with controls
- `PdfViewer` - PDF display with Syncfusion
- `MarkdownViewer` - Rendered markdown
- `MhtmlViewer` - MHTML content (basic)

**Future Widget Ideas**:
```dart
// SearchBar widget
// FilterPanel widget
// SortDropdown widget
// BreadcrumbNavigation widget
// FilePreview (thumbnails)
// ProgressIndicator (file uploads)
```

## Adding New Features

### Feature 1: Search Functionality

**Step-by-step Implementation**:

1. **Add search state to HomeScreen**:
```dart
String _searchQuery = '';

void _onSearchChanged(String query) {
  setState(() {
    _searchQuery = query;
  });
}
```

2. **Create SearchBar widget**:
```dart
// lib/widgets/search_bar.dart
class ResourceSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  
  // Build TextField with search icon
  // Call onSearchChanged when text changes
}
```

3. **Filter resources**:
```dart
List<ResourceItem> get _filteredResources {
  if (_searchQuery.isEmpty) return _resources;
  
  return _resources.where((r) =>
    r.name.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();
}
```

4. **Update UI**:
```dart
// Pass _filteredResources instead of _resources
ResourceList(
  resources: _filteredResources,
  onResourceSelected: _onResourceSelected,
)
```

### Feature 2: Sorting

**Implementation**:

1. **Add sort state**:
```dart
enum SortType { name, type, date }
SortType _currentSort = SortType.name;
bool _sortAscending = true;
```

2. **Create sort method**:
```dart
List<ResourceItem> _getSortedResources() {
  final list = List<ResourceItem>.from(_filteredResources);
  
  switch (_currentSort) {
    case SortType.name:
      list.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortType.type:
      list.sort((a, b) => a.type.compareTo(b.type));
      break;
  }
  
  if (!_sortAscending) {
    return list.reversed.toList();
  }
  return list;
}
```

3. **Add sort UI**:
```dart
// Dropdown or buttons in the sidebar header
// Update _currentSort on selection
// Rebuild UI with sorted list
```

### Feature 3: Automatic Rescanning

**Current**: Manual refresh button

**Enhancement**: Auto-refresh every N minutes

```dart
Timer? _refreshTimer;

@override
void initState() {
  super.initState();
  _loadResources();
  
  // Auto-refresh every 5 minutes
  _refreshTimer = Timer.periodic(
    Duration(minutes: 5),
    (_) => _loadResources(),
  );
}

@override
void dispose() {
  _refreshTimer?.cancel();
  super.dispose();
}
```

### Feature 4: Folder Navigation

**Major Enhancement** for later iterations

```dart
// 1. Update ResourceItem model
class ResourceItem {
  final String parentFolder;
  // ... other fields
}

// 2. Create FolderService
class FolderService {
  Future<List<String>> getFolders();
  Future<List<ResourceItem>> getResourcesInFolder(String path);
}

// 3. Add folder state to HomeScreen
String _currentFolder = '/';
List<String> _folderPath = ['/'];

// 4. Create BreadcrumbNavigation widget
// 5. Update UI to show current folder
// 6. Add back/forward navigation
```

## Code Style Guidelines

### Naming Conventions

```dart
// Classes: PascalCase
class ResourceItem { }

// Variables: camelCase
String fileName;

// Private members: _underscore
String _privateVariable;

// Constants: lowerCamelCase (or UPPER_CASE for compile-time constants)
const primaryColor = Colors.blue;
```

### File Organization

```
lib/
├── models/           # Data structures only
├── services/         # Business logic, API calls
├── screens/          # Full-page views
├── widgets/          # Reusable components
└── utils/           # Helper functions (future)
```

### Comment Guidelines

```dart
/// Documentation comments (for public APIs)
/// Use /// with complete sentences

// Regular comments (explain WHY, not WHAT)
// The code itself should be clear enough

// Good:
// Sort by name to match user expectations
resources.sort((a, b) => a.name.compareTo(b.name));

// Bad:
// Sort the resources
resources.sort((a, b) => a.name.compareTo(b.name));
```

## Performance Optimization (Future)

### Current Performance

- ✅ Simple, fast for <1000 files
- ✅ No unnecessary rebuilds
- ⚠️ Loads all resources at once
- ⚠️ No pagination
- ⚠️ No lazy loading

### Optimization Strategies

1. **Pagination**
```dart
// Load 50 items at a time
// Infinite scroll
// Reduce initial load time
```

2. **Virtual Scrolling**
```dart
// Only render visible items
// Great for thousands of files
// Use flutter_sticky_headers package
```

3. **Image Thumbnails**
```dart
// Generate thumbnails server-side
// Show preview before full load
// Cache thumbnails locally
```

4. **State Management**
```dart
// Move from setState to Provider/Riverpod
// Selective rebuilds
// Better performance for complex apps
```

## Testing Strategy

### Current: No tests (beginner project)

### Future Test Structure

```
test/
├── unit/
│   ├── models/
│   │   └── resource_item_test.dart
│   └── services/
│       └── file_scanner_test.dart
├── widget/
│   ├── resource_list_test.dart
│   └── resource_viewer_test.dart
└── integration/
    └── full_app_test.dart
```

### Example Unit Test

```dart
// test/unit/models/resource_item_test.dart
void main() {
  group('ResourceItem', () {
    test('creates from video path correctly', () {
      final item = ResourceItem.fromPath('videos/test.mp4');
      
      expect(item.name, 'test.mp4');
      expect(item.type, 'video');
      expect(item.extension, 'mp4');
    });
  });
}
```

## Deployment Considerations

### Current Setup

- ✅ Static web app
- ✅ No backend needed
- ✅ Easy to host
- ⚠️ Manual manifest updates
- ⚠️ No server-side scanning

### Production Enhancements

1. **Add Backend API**
```
GET /api/resources      # List all resources
GET /api/resource/:id   # Get specific resource
GET /api/folders        # List folders
POST /api/scan          # Trigger rescan
```

2. **Authentication**
```dart
// Add login screen
// Token-based auth
// Protected resources
```

3. **Analytics**
```dart
// Track most viewed files
// Monitor load times
// Error tracking
```

## Common Tasks

### Adding a New File Type

1. Update `ResourceItem.fromPath()`:
```dart
else if (['doc', 'docx'].contains(extension)) {
  type = 'document';
}
```

2. Create viewer widget:
```dart
// lib/widgets/document_viewer.dart
class DocumentViewer extends StatelessWidget {
  // Implement document display
}
```

3. Add to ResourceViewer switch:
```dart
case 'document':
  return DocumentViewer(resource: resource);
```

### Changing the Theme

Edit `lib/main.dart`:
```dart
theme: ThemeData(
  primarySwatch: Colors.green,  // Change color
  brightness: Brightness.dark,   // Dark mode
  fontFamily: 'Arial',           // Change font
)
```

### Adding a New Screen

1. Create file: `lib/screens/new_screen.dart`
2. Define StatefulWidget
3. Add navigation:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

## Resources for Learning

- **Flutter Docs**: https://docs.flutter.dev
- **Dart Docs**: https://dart.dev
- **Flutter Widget Catalog**: https://docs.flutter.dev/development/ui/widgets
- **Package Repository**: https://pub.dev

## Questions to Consider for Next Iteration

1. Do you need folder navigation?
2. How many resources will you have? (impacts pagination decisions)
3. Do you need user authentication?
4. Should resources be editable?
5. Do you want to upload new resources through the app?
6. Do you need offline support?
7. Should there be user preferences/settings?

---

**This is a solid foundation. Build from here incrementally!**
