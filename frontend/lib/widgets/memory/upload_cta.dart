import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart'; // Exposed by desktop_drop

class MemoryFile {
  final String name;
  final Uint8List bytes;
  final String? path; // Optional, for reference

  MemoryFile({required this.name, required this.bytes, this.path});
}

class UploadCTA extends StatefulWidget {
  final bool isProcessing;
  final int currentCount;
  final Function(List<MemoryFile>) onFilesSelected;

  const UploadCTA({
    super.key,
    required this.isProcessing,
    required this.currentCount,
    required this.onFilesSelected,
  });

  static const int maxFiles = 5;

  @override
  State<UploadCTA> createState() => _UploadCTAState();
}

class _UploadCTAState extends State<UploadCTA> with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isDropEnabled {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleDroppedFiles(List<XFile> droppedFiles) async {
    if (widget.currentCount >= UploadCTA.maxFiles) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Memory Bank is full. Please delete an entry to upload more.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final List<MemoryFile> files = [];
    final allowedExtensions = ['pdf', 'docx', 'txt', 'md'];

    for (var file in droppedFiles) {
      final ext = file.name.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Skipping ${file.name}: Unsupported file type.'),
            backgroundColor: Colors.orange,
          ),
        );
        continue;
      }

      try {
        files.add(MemoryFile(
          name: file.name,
          bytes: await file.readAsBytes(),
          path: file.path,
        ));
      } catch (e) {
        debugPrint('Error reading dropped file ${file.path}: $e');
      }
    }

    if (files.isNotEmpty) {
      widget.onFilesSelected(files);
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    if (widget.currentCount >= UploadCTA.maxFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Memory Bank is full. Please delete an entry to upload more.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt', 'md'],
        allowMultiple: true,
        withData: true, // Important for web and possibly desktop
      );

      if (result != null) {
        if (!context.mounted) return;
        
        final List<MemoryFile> files = [];
        
        for (var file in result.files) {
          if (file.bytes != null) {
            files.add(MemoryFile(name: file.name, bytes: file.bytes!, path: file.path));
          } else if (file.path != null) {
            try {
              final detectedFile = File(file.path!);
              files.add(MemoryFile(
                name: file.name, 
                bytes: await detectedFile.readAsBytes(),
                path: file.path
              ));
            } catch (e) {
              debugPrint('Error reading file ${file.path}: $e');
            }
          }
        }

        if (context.mounted && files.isNotEmpty) {
          widget.onFilesSelected(files);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _updateDragState(bool isDragging) {
    setState(() {
      _isDragging = isDragging;
      if (_isDragging) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    });
  }

  Widget _buildContent(BuildContext context) {
    final bool isFull = widget.currentCount >= UploadCTA.maxFiles;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Visual styles based on state
    final backgroundColor = _isDragging 
        ? primaryColor.withValues(alpha: 0.15) 
        : primaryColor.withValues(alpha: 0.05);

    final borderColor = _isDragging
        ? primaryColor
        : primaryColor.withValues(alpha: 0.2);
        
    final iconColor = isFull 
        ? Colors.grey 
        : (_isDragging ? primaryColor : primaryColor);
        
    final iconSize = _isDragging ? 64.0 : 48.0;

    return CustomPaint(
      painter: _isDragging ? _DashedBorderPainter(color: primaryColor) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          // Use standard border when not dragging, CustomPaint handles dashed border when dragging
          border: _isDragging ? null : Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            AnimatedScale(
              scale: _isDragging ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: iconSize,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isDragging 
                  ? 'Drop files here'
                  : (isFull ? 'Memory Bank Full' : 'Upload Context Document'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isFull ? Colors.grey : (_isDragging ? primaryColor : null),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: PDF, DOCX, TXT, MD',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.currentCount} of ${UploadCTA.maxFiles} slots used',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isFull ? Colors.orange : Colors.grey[600],
                    fontWeight: isFull ? FontWeight.bold : null,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (widget.isProcessing || isFull) ? null : () => _pickFile(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: _isDragging ? 0 : 2, // Flatten button when dragging
                ),
                child: widget.isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 200,
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const Text(
                        'Select File',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDropEnabled) return _buildContent(context);

    return DropTarget(
      onDragEntered: (_) => _updateDragState(true),
      onDragExited: (_) => _updateDragState(false),
      onDragDone: (details) {
        _updateDragState(false);
        _handleDroppedFiles(details.files);
      },
      child: _buildContent(context),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth = 2.0;
  final double dashWidth = 8.0;
  final double dashSpace = 4.0;
  final double radius = 24.0;

  _DashedBorderPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _createDashedPath(path, dashWidth, dashSpace);

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path path = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        path.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
