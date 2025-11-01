import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
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
  final Function(String)? onMarkdownContentLoaded;

  const ResourceViewer({
    super.key,
    required this.resource,
    this.onMarkdownContentLoaded,
  });

  @override
  Widget build(BuildContext context) {
    // Display different viewers based on file type
    switch (resource.type) {
      case 'video':
        return VideoViewer(resource: resource);
      case 'pdf':
        return PdfViewer(resource: resource);
      case 'markdown':
        return MarkdownViewer(
          resource: resource,
          onMarkdownContentLoaded: onMarkdownContentLoaded,
          );
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
/// Displays PDF files using browser's native PDF viewer (iframe)
/// This is more reliable for web than external packages
class PdfViewer extends StatefulWidget {
  final ResourceItem resource;

  const PdfViewer({Key? key, required this.resource}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _viewType;

  @override
  void initState() {
    super.initState();
    _initializePdfViewer();
  }

  /// Initialize PDF viewer with iframe
  Future<void> _initializePdfViewer() async {
    try {
      // Get the base URL from the current window location
      final baseUrl = html.window.location.origin;
      
      // Construct full PDF URL
      String pdfPath = widget.resource.path;
      String fullPdfUrl;
      
      if (pdfPath.startsWith('http')) {
        // Already a full URL
        fullPdfUrl = pdfPath;
      } else {
        // Relative path - construct full URL
        if (!pdfPath.startsWith('/')) {
          pdfPath = '/$pdfPath';
        }
        fullPdfUrl = '$baseUrl$pdfPath';
      }
      
      print('Attempting to load PDF from: $fullPdfUrl');
      
      // Check if PDF is accessible
      final response = await http.head(Uri.parse(fullPdfUrl));
      
      if (response.statusCode == 200) {
        // Create unique view type
        _viewType = 'pdf-${widget.resource.path.hashCode}';
        
        // Register iframe factory
        ui_web.platformViewRegistry.registerViewFactory(
          _viewType!,
          (int viewId) {
            final iframe = html.IFrameElement()
              ..src = fullPdfUrl
              ..style.border = 'none'
              ..style.width = '100%'
              ..style.height = '100%';
            return iframe;
          },
        );
        
        setState(() {
          _isLoading = false;
        });
      } else {
        print('PDF request returned status: ${response.statusCode}');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading PDF...'),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load PDF',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.resource.path,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Troubleshooting:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Check if the file exists in web/resources/'),
                  Text('• Verify the path in resources_manifest.txt'),
                  Text('• Make sure the PDF is not corrupted'),
                  Text('• Try opening the PDF directly in browser'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _hasError = false;
                    });
                    _initializePdfViewer();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final baseUrl = html.window.location.origin;
                    String pdfPath = widget.resource.path;
                    String fullPdfUrl;
                    
                    if (pdfPath.startsWith('http')) {
                      fullPdfUrl = pdfPath;
                    } else {
                      if (!pdfPath.startsWith('/')) {
                        pdfPath = '/$pdfPath';
                      }
                      fullPdfUrl = '$baseUrl$pdfPath';
                    }
                    
                    html.window.open(fullPdfUrl, '_blank');
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open in New Tab'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Display PDF in iframe
    return Column(
      children: [
        // Info banner
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Use browser controls to zoom and navigate the PDF',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  final baseUrl = html.window.location.origin;
                  String pdfPath = widget.resource.path;
                  String fullPdfUrl;
                  
                  if (pdfPath.startsWith('http')) {
                    fullPdfUrl = pdfPath;
                  } else {
                    if (!pdfPath.startsWith('/')) {
                      pdfPath = '/$pdfPath';
                    }
                    fullPdfUrl = '$baseUrl$pdfPath';
                  }
                  
                  html.window.open(fullPdfUrl, '_blank');
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open in New Tab'),
              ),
            ],
          ),
        ),
        // PDF iframe
        Expanded(
          child: HtmlElementView(
            viewType: _viewType!,
          ),
        ),
      ],
    );
  }
}

/// MarkdownViewer Widget
/// 
/// Displays markdown files with proper formatting
class MarkdownViewer extends StatefulWidget {
  final ResourceItem resource;
  final Function(String)? onContentLoaded;

  const MarkdownViewer({
    super.key, 
    required this.resource,
    this.onContentLoaded, Function(String p1)? onMarkdownContentLoaded,
    });

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

        // Call the callback with the content for TOC extraction
        if (widget.onContentLoaded != null) {
          widget.onContentLoaded!(_markdownContent);
        }
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
      padding: EdgeInsets.all(16),
      child: Text(
        _content,
        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}