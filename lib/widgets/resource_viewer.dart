import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../models/resource_item.dart';

/// ResourceViewer Widget
/// 
/// This widget displays the content of a selected resource file.
/// It handles different file types and renders them appropriately:
/// - Videos: Uses video player
/// - PDFs: Uses PDF viewer
/// - Markdown: Renders formatted markdown
/// - MHTML: Displays as HTML (simplified in this version)
class ResourceViewer extends StatelessWidget {
  final ResourceItem resource;

  const ResourceViewer({
    Key? key,
    required this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Display different viewers based on file type
    switch (resource.type) {
      case 'video':
        return VideoViewer(resource: resource);
      case 'pdf':
        return PdfViewer(resource: resource);
      case 'markdown':
        return MarkdownViewer(resource: resource);
      case 'mhtml':
        return MhtmlViewer(resource: resource);
      default:
        return Center(
          child: Text('Unsupported file type: ${resource.type}'),
        );
    }
  }
}

/// VideoViewer Widget
/// 
/// Displays video files using the video_player package
class VideoViewer extends StatefulWidget {
  final ResourceItem resource;

  const VideoViewer({Key? key, required this.resource}) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  // The video player controller
  late VideoPlayerController _controller;
  
  // Track initialization state
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  /// Initialize the video player
  Future<void> _initializeVideo() async {
    try {
      // Create a network video player controller
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.resource.path),
      );

      // Initialize the controller
      await _controller.initialize();

      // Update state when ready
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if video failed to load
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load video'),
            const SizedBox(height: 8),
            Text(widget.resource.path, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Show loading indicator while initializing
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Display the video player
    return Column(
      children: [
        // Video player with aspect ratio
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        
        // Video controls
        Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Play/Pause button
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              
              // Progress indicator
              Expanded(
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.blue,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// PdfViewer Widget
/// 
/// Displays PDF files using Syncfusion PDF viewer
class PdfViewer extends StatelessWidget {
  final ResourceItem resource;

  const PdfViewer({Key? key, required this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      resource.path,
      // Show loading indicator while PDF loads
      onDocumentLoadFailed: (details) {
        // Show error message if PDF fails to load
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load PDF: ${details.description}')),
        );
      },
    );
  }
}

/// MarkdownViewer Widget
/// 
/// Displays markdown files with proper formatting
class MarkdownViewer extends StatefulWidget {
  final ResourceItem resource;

  const MarkdownViewer({Key? key, required this.resource}) : super(key: key);

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  // Store the markdown content
  String _markdownContent = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  /// Load the markdown file content
  Future<void> _loadMarkdown() async {
    try {
      final response = await http.get(Uri.parse(widget.resource.path));
      
      if (response.statusCode == 200) {
        setState(() {
          _markdownContent = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading markdown: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load markdown file'),
          ],
        ),
      );
    }

    // Display the markdown content with styling
    return Markdown(
      data: _markdownContent,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        p: const TextStyle(fontSize: 16),
      ),
    );
  }
}

/// MhtmlViewer Widget
/// 
/// Displays MHTML files (simplified version - shows as text for now)
/// In future iterations, this could be enhanced to render actual HTML
class MhtmlViewer extends StatefulWidget {
  final ResourceItem resource;

  const MhtmlViewer({Key? key, required this.resource}) : super(key: key);

  @override
  State<MhtmlViewer> createState() => _MhtmlViewerState();
}

class _MhtmlViewerState extends State<MhtmlViewer> {
  String _content = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMhtml();
  }

  /// Load the MHTML file content
  Future<void> _loadMhtml() async {
    try {
      final response = await http.get(Uri.parse(widget.resource.path));
      
      if (response.statusCode == 200) {
        setState(() {
          _content = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading MHTML: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load MHTML file'),
          ],
        ),
      );
    }

    // For now, display as scrollable text
    // In future iterations, this could render the HTML properly
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        _content,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}
