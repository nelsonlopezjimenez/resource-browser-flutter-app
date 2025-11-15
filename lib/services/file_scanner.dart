import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/resource_item.dart';

/// FileScanner Service
/// 
/// This service is responsible for scanning the public folder and finding all
/// video, PDF, markdown, and MHTML files. In this first iteration, we're using
/// a simple approach with a manifest file.
/// 
/// HOW IT WORKS:
/// 1. You need to create a file called 'resources_manifest.txt' in your public folder
/// 2. List all your resource files in that text file (one per line)
/// 3. This service reads that manifest and creates ResourceItem objects
/// 
/// Example manifest file content:
/// resources/video1.mp4
/// resources/document.pdf
/// resources/readme.md
/// resources/page.mhtml
class FileScanner {
  // The base URL where your files are hosted
  // For local development, this is typically the root of your web server
  final String baseUrl;

  /// Constructor
  /// 
  /// Parameters:
  ///   - baseUrl: The base URL where files are hosted (default: current site root)
  FileScanner({this.baseUrl = ''});

  /// Scans the public folder for resource files
  /// 
  /// Returns a list of ResourceItem objects representing all found files.
  /// This is an async method because it needs to fetch data from the server.
  Future<List<ResourceItem>> scanResources() async {
    try {
      // Fetch the manifest file that lists all resources
      // The manifest file should be placed in the web folder of your Flutter project
      final response = await http.get(
        Uri.parse('$baseUrl/resources_manifest.txt'),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // CHANGED: Use utf8.decode instead of response.body
        // This ensures proper handling of UTF-8 characters including emoji
        final content = utf8.decode(response.bodyBytes, allowMalformed: true);

        // Split the file content into lines
        final lines = content.split('\n');
        
        // Convert each line into a ResourceItem
        final resources = <ResourceItem>[];
        
        for (final line in lines) {
          // Clean up the line (remove extra spaces and newlines)
          final trimmedLine = line.trim();
          
          // Skip empty lines
          if (trimmedLine.isEmpty) continue;
          
          // Skip comment lines (lines starting with #)
          if (trimmedLine.startsWith('#')) continue;
          
          // Create a ResourceItem from the path
          final resource = ResourceItem.fromPath(trimmedLine);
          
          // Only add supported file types
          if (resource.type != 'unknown') {
            resources.add(resource);
          }
        }
        
        return resources;
      } else {
        // If the manifest file is not found, return an empty list
        print('Manifest file not found. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // If there's any error (network error, etc.), print it and return empty list
      print('Error scanning resources: $e');
      return [];
    }
  }

  /// Load a markdown file with proper UTF-8 encoding
  /// 
  /// This method specifically handles loading markdown files and ensures
  /// that special characters and emoji are properly displayed.
  Future<String> loadMarkdownFile(String filePath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$filePath'),
      );

      if (response.statusCode == 200) {
        // IMPORTANT: Decode as UTF-8 to preserve emoji and special characters
        return utf8.decode(response.bodyBytes, allowMalformed: true);
      } else {
        throw Exception('Failed to load file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading markdown file: $e');
    }
  }

  /// Load any text-based file with UTF-8 encoding
  /// 
  /// Use this for MHTML or any other text-based files
  Future<String> loadTextFile(String filePath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$filePath'),
      );

      if (response.statusCode == 200) {
        // Decode as UTF-8
        return utf8.decode(response.bodyBytes, allowMalformed: true);
      } else {
        throw Exception('Failed to load file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading text file: $e');
    }
  }

  /// Alternative method: Scan using a JSON manifest
  /// 
  /// This is for future iterations where you might want a more structured manifest.
  /// For now, we're keeping it simple with a text file.
  /// 
  /// Example JSON format:
  /// {
  ///   "resources": [
  ///     {"path": "resources/video1.mp4", "title": "Introduction Video"},
  ///     {"path": "resources/guide.pdf", "title": "User Guide"}
  ///   ]
  /// }
  // Future<List<ResourceItem>> scanResourcesFromJson() async {
  //   // Implementation for JSON-based scanning (for future iterations)
  // }
}
