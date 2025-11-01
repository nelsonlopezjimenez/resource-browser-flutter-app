import 'package:flutter/material.dart';
import '../models/resource_item.dart';
import '../models/folder_item.dart';
import '../services/file_scanner.dart';
import '../widgets/resource_list.dart';
import '../widgets/resource_viewer.dart';

/// HomeScreen Widget
/// 
/// This is the main screen of the application. It has two main sections:
/// 1. Left sidebar: Shows a list of all available resources
/// 2. Right content area: Displays the selected resource
/// 
/// The screen handles:
/// - Loading resources when the app starts
/// - Selecting and displaying resources
/// - Providing a refresh button to rescan for new files
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // The file scanner service
  final FileScanner _scanner = FileScanner();
  
  // List of all available resources
  List<ResourceItem> _resources = [];
  
  // Organized folders
  List<FolderItem> _folders = [];
  
  // The currently selected resource (null if none selected)
  ResourceItem? _selectedResource;
  
  // Track loading state
  bool _isLoading = true;

  // Table of contents for markdown files
  List<String> _tocHeadings = [];

  @override
  void initState() {
    super.initState();
    // Load resources when the screen first appears
    _loadResources();
  }

  /// Load (or reload) resources from the public folder
  Future<void> _loadResources() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Scan for resources using the FileScanner service
      final resources = await _scanner.scanResources();

      // Organize resources into folders
      _organizeFolders(resources);
      
      setState(() {
        _resources = resources;
        _isLoading = false;
        
        // If a resource was selected and still exists, keep it selected
        // Otherwise, clear the selection
        if (_selectedResource != null) {
          final stillExists = resources.any(
            (r) => r.path == _selectedResource!.path,
          );
          if (!stillExists) {
            _selectedResource = null;
          }
        }
      });
    } catch (e) {
      print('Error loading resources: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Organize resources into folders based on their paths 
  void _organizeFolders(List<ResourceItem> resources) {
    // Map to hold folder name -> resources
    Map<String, List<ResourceItem>> folderMap = {};

    for (var resource in resources) {
      String folderName;

      // Determine folder based on path or type
     if (resource.path.contains('section1-html-css') || 
          resource.path.toLowerCase().contains('section1') ||
          resource.path.toLowerCase().contains('html-css')) {
        folderName = 'Section 1 - HTML & CSS';
      } else if (resource.path.contains('section2-javascript') || 
                 resource.path.toLowerCase().contains('section2') ||
                 resource.path.toLowerCase().contains('javascript')) {
        folderName = 'Section 2 - JavaScript';
      } else if (resource.path.contains('section3-backend') || 
                 resource.path.toLowerCase().contains('section3') ||
                 resource.path.toLowerCase().contains('backend')) {
        folderName = 'Section 3 - Backend';
      } else if (resource.path.contains('section4-react') || 
                 resource.path.toLowerCase().contains('section4') ||
                 resource.path.toLowerCase().contains('react')) {
        folderName = 'Section 4 - React';
      } else if (resource.type == 'video') {
        folderName = 'Videos';
      } else if (resource.type == 'pdf') {
        folderName = 'PDFs';
      } else if (resource.type == 'markdown') {
        folderName = 'Documents';
      } else {
        folderName = 'Other Resources';
      }

      // Add to folder map
      if (!folderMap.containsKey(folderName)) {
        folderMap[folderName] = [];
      }
      folderMap[folderName]!.add(resource);
    }

    // Convert map to list of FolderItems
    _folders = folderMap.entries.map((entry) {
      return FolderItem(
        name:entry.key,
        resources: entry.value,
        isExpanded: false, // Start collapsed
      );
    }).toList();

    // Sort folders by name
    _folders.sort((a, b) => a.name.compareTo(b.name));
  }

  /// Handle resource selection
  void _onResourceSelected(ResourceItem resource) {
    setState(() {
      _selectedResource = resource;
      _tocHeadings = [] // Clear TOC when swithching resources
    });

    // If it's a markdown file, we'll extract headings
    // The ResourceViewer will call our callback with the content
  }

  /// Callback to receive markdown content aqnd extract TOC
  void _onMarkdownContentLoaded(String content) {
    setState( () {
      _tocHeadings = _extractHeadings(content);
    });
  }

  /// Extract Headings from markdown content
  List<String> _extractHeadings(String content) {
    final headings = <String>[];
    final lines = content.split('\n');

    for (var line in lines) {
      final trimmed = line.trim();
      // Match headings (#, ##, ####)
      if (trimmed.startsWith('#')) {
        headings.add(trimmed);
      }
    }

    return headings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: const Text('Resource Browser'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button to rescan for new files
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh resources',
            onPressed: _isLoading ? null : _loadResources,
          ),
        ],
      ),
      
      // Main content area
      body: Row(
        children: [
          // Left sidebar - Resource list
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                right: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Sidebar header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Lessons Selection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Resource count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_resources.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Folder List // Resource list or loading indicator
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildFolderList(),
                ),
              ],
            ),
          ),

          // Center content area - REsource viewer          
          Expanded(
            child: _buildContentArea(),
          ),

        // Right sidebar - Table of Contents (only show for markdown)
                  if (_selectedResource?.type == 'markdown')
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  left: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: _buildTableOfContents(),
            ),
        ],
      ),
    );
  }

  /// Build the content area (right side of the screen)
  Widget _buildContentArea() {
    // If no resource is selected, show a welcome message
    if (_selectedResource == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.touch_app,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a resource to view',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose from the list on the left',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    // Display the selected resource
    return Column(
      children: [
        // Header showing the selected file name
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Back button (clears selection)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedResource = null;
                  });
                },
              ),
              const SizedBox(width: 8),
              
              // File name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedResource!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _selectedResource!.path,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Resource viewer
        Expanded(
          child: ResourceViewer(
            resource: _selectedResource!,
            onMarkdownContentLoaded: _onMarkdownContentLoaded,
            ),
        ),
      ],
    );
  }

  /// Build the folder list with expandable sections
  Widget _buildFolderList() {
    if (_folders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No resources found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        
        return Column(
          children: [
            // Folder header (clickable)
            InkWell(
              onTap: () {
                setState(() {
                  folder.isExpanded = !folder.isExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      folder.isExpanded 
                          ? Icons.keyboard_arrow_down 
                          : Icons.keyboard_arrow_right,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      folder.isExpanded ? Icons.folder_open : Icons.folder,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        folder.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Resource count
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${folder.resources.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Folder contents (expandable)
            if (folder.isExpanded)
              ...folder.resources.map((resource) {
                final isSelected = _selectedResource?.path == resource.path;
                
                return InkWell(
                  onTap: () => _onResourceSelected(resource),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 3,
                        ),
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 40), // Indent for hierarchy
                        Icon(
                          _getIconForType(resource.type),
                          size: 16,
                          color: _getColorForType(resource.type),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resource.name,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.blue : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }

  /// Get icon for resource type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'markdown':
        return Icons.article;
      case 'mhtml':
        return Icons.web;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get color for resource type
  Color _getColorForType(String type) {
    switch (type) {
      case 'video':
        return Colors.red;
      case 'pdf':
        return Colors.orange;
      case 'markdown':
        return Colors.blue;
      case 'mhtml':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Build table of contents sidebar
  Widget _buildTableOfContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOC Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.list, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Table of Contents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // TOC Items
        Expanded(
          child: _tocHeadings.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Loading...',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _tocHeadings.length,
                  itemBuilder: (context, index) {
                    final heading = _tocHeadings[index];
                    final level = _getHeadingLevel(heading);
                    final text = heading.replaceAll('#', '').trim();
                    
                    return InkWell(
                      onTap: () {
                        // TODO: Scroll to heading in content (future enhancement)
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16 + (level - 1) * 12.0,
                          right: 16,
                          top: 6,
                          bottom: 6,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: level == 1 ? 13 : 12,
                            fontWeight: level == 1 ? FontWeight.w600 : FontWeight.normal,
                            color: level == 1 ? Colors.black87 : Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Get heading level from markdown heading
  int _getHeadingLevel(String heading) {
    int level = 0;
    for (var char in heading.characters) {
      if (char == '#') {
        level++;
      } else {
        break;
      }
    }
    return level;
  }
}
