import 'package:flutter/material.dart';
import '../models/resource_item.dart';

/// ResourceList Widget
/// 
/// This widget displays a grid of resource cards. Each card represents one file
/// and shows its icon, name, and type. When clicked, it notifies the parent
/// widget so the file can be displayed.
class ResourceList extends StatelessWidget {
  // List of resources to display
  final List<ResourceItem> resources;
  
  // Callback function when a resource is selected
  // This allows the parent widget to know which file was clicked
  final Function(ResourceItem) onResourceSelected;

  /// Constructor
  const ResourceList({
    super.key,
    required this.resources,
    required this.onResourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    // If there are no resources, show a helpful message
    if (resources.isEmpty) {
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
            SizedBox(height: 8),
            Text(
              'Make sure resources_manifest.txt exists in the web folder',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Display resources in a responsive grid
    return GridView.builder(
      // Padding around the entire grid
      padding: const EdgeInsets.all(16),
      
      // GridView configuration
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // Number of columns (2 on most screens)
        crossAxisCount: 2,
        
        // Spacing between cards
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        
        // Aspect ratio of each card (width / height) - increased for more vertical space
        childAspectRatio: 1.2,
      ),
      
      // Number of items in the grid
      itemCount: resources.length,
      
      // Builder function - creates a widget for each resource
      itemBuilder: (context, index) {
        final resource = resources[index];
        
        // Return a card for this resource
        return _ResourceCard(
          resource: resource,
          onTap: () => onResourceSelected(resource),
        );
      },
    );
  }
}

/// _ResourceCard Widget (Private)
/// 
/// A single card that represents one resource file.
/// Shows the file icon, name, and type with a nice hover effect.
class _ResourceCard extends StatefulWidget {
  final ResourceItem resource;
  final VoidCallback onTap;

  const _ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
  });

  @override
  State<_ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<_ResourceCard> {
  // Track if the mouse is hovering over this card
  bool _isHovered = false;

  // Get the appropriate color for each file type
  Color _getTypeColor() {
    switch (widget.resource.type) {
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

  // Get the appropriate icon for each file type
  IconData _getTypeIcon() {
    switch (widget.resource.type) {
      case 'video':
        return Icons.video_library;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'markdown':
        return Icons.description;
      case 'mhtml':
        return Icons.web;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Update hover state when mouse enters/exits
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      
      child: Card(
        // Slight elevation that increases on hover for a nice effect
        elevation: _isHovered ? 8 : 2,
        
        child: InkWell(
          // Call the callback when tapped
          onTap: widget.onTap,
          
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // File type icon
                Icon(
                  _getTypeIcon(),
                  size: 36,
                  color: _getTypeColor(),
                ),
                
                const SizedBox(height: 8),
                
                // File name (truncated if too long)
                Flexible(
                  child: Text(
                    widget.resource.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // File type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.resource.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      color: _getTypeColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}