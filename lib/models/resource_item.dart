/// ResourceItem Model
/// 
/// This class represents a single file (resource) found in the public folder.
/// It stores all the information we need about each file like name, type, and path.
class ResourceItem {
  // The full name of the file including extension (e.g., "video.mp4")
  final String name;
  
  // The type of file: 'video', 'pdf', 'markdown', or 'mhtml'
  final String type;
  
  // The relative path to the file from the public folder (e.g., "resources/video.mp4")
  final String path;
  
  // The file extension (e.g., "mp4", "pdf", "md")
  final String extension;

  /// Constructor - creates a new ResourceItem
  /// 
  /// Parameters:
  ///   - name: The file name
  ///   - type: The type of resource
  ///   - path: The path to the file
  ///   - extension: The file extension
  ResourceItem({
    required this.name,
    required this.type,
    required this.path,
    required this.extension,
  });

  /// Factory constructor to create a ResourceItem from the file path
  /// 
  /// This method automatically determines the file type based on its extension.
  /// Example: "folder/video.mp4" -> creates a ResourceItem with type 'video'
  factory ResourceItem.fromPath(String filePath) {
    // Extract just the filename from the full path
    final fileName = filePath.split('/').last;
    
    // Get the file extension (everything after the last dot)
    final extension = fileName.contains('.') 
        ? fileName.split('.').last.toLowerCase() 
        : '';
    
    // Determine the type based on extension
    String type;
    if (['mp4', 'webm', 'ogg'].contains(extension)) {
      type = 'video';
    } else if (extension == 'pdf') {
      type = 'pdf';
    } else if (['md', 'markdown'].contains(extension)) {
      type = 'markdown';
    } else if (['mhtml', 'mht'].contains(extension)) {
      type = 'mhtml';
    } else {
      type = 'unknown';
    }

    return ResourceItem(
      name: fileName,
      type: type,
      path: filePath,
      extension: extension,
    );
  }

  /// Returns a user-friendly icon name based on the file type
  /// This will be used to show different icons for different file types
  String getIconName() {
    switch (type) {
      case 'video':
        return 'video_library';
      case 'pdf':
        return 'picture_as_pdf';
      case 'markdown':
        return 'description';
      case 'mhtml':
        return 'web';
      default:
        return 'insert_drive_file';
    }
  }
}
