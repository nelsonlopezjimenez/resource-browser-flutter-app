import 'package:flutter/material.dart';
import '../models/resource_item.dart';
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
  
  // The currently selected resource (null if none selected)
  ResourceItem? _selectedResource;
  
  // Track loading state
  bool _isLoading = true;

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

  /// Handle resource selection
  void _onResourceSelected(ResourceItem resource) {
    setState(() {
      _selectedResource = resource;
    });
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
                        'Resources',
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
                
                // Resource list or loading indicator
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ResourceList(
                          resources: _resources,
                          onResourceSelected: _onResourceSelected,
                        ),
                ),
              ],
            ),
          ),
          
          // Right content area - Resource viewer
          Expanded(
            child: _buildContentArea(),
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
          child: ResourceViewer(resource: _selectedResource!),
        ),
      ],
    );
  }
}
