import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A widget that only loads images when they become visible in the viewport.
/// This significantly improves initial load time by deferring non-critical images.
class LazyImage extends StatefulWidget {
  const LazyImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Duration fadeInDuration;

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  bool _shouldLoad = false;
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('lazy_image_${widget.imagePath}'),
      onVisibilityChanged: (info) {
        // Load when at least 10% visible
        if (info.visibleFraction > 0.1 && !_shouldLoad) {
          setState(() {
            _shouldLoad = true;
          });
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _shouldLoad
            ? Image.asset(
                widget.imagePath,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    if (!_isLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _isLoaded = true;
                          });
                        }
                      });
                    }
                    return child;
                  }
                  return widget.placeholder ?? const SizedBox();
                },
                errorBuilder: (context, error, stackTrace) {
                  return widget.placeholder ??
                      Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      );
                },
              )
            : widget.placeholder ??
                  Container(
                    color: Colors.grey[100],
                    width: widget.width,
                    height: widget.height,
                  ),
      ),
    );
  }
}
