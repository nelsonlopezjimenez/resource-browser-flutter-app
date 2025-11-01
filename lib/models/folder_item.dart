import 'resource_item.dart';

/// FolderItem Model
/// 
/// Represents a folder/section in the sidebar navigation
/// Contains a list of resources that belong to this folder
class FolderItem {
  // The display name of the folder (e.g., "Section 1 - HTML CSS")
  final String name;
  
  // List of resources in this folder
  final List<ResourceItem> resources;
  
  // Whether this folder is currently expanded in the UI
  bool isExpanded;

  /// Constructor
  FolderItem({
    required this.name,
    required this.resources,
    this.isExpanded = false,
  });
}