import 'package:flutter/material.dart';

class EmojiCursor extends StatefulWidget {
  final Widget child;
  final String emoji;

  const EmojiCursor({
    super.key,
    required this.child,
    this.emoji = '💐', // Easy to change here
  });

  @override
  State<EmojiCursor> createState() => _EmojiCursorState();
}

class _EmojiCursorState extends State<EmojiCursor> {
  Offset _pointerPosition = Offset.zero;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Hide the native cursor
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      onHover: (event) {
        setState(() {
          _pointerPosition = event.position;
        });
      },
      child: Stack(
        children: [
          // The actual app content
          widget.child,
          
          // The custom emoji cursor
          if (_isHovering)
            Positioned(
              left: _pointerPosition.dx - 8, // Offset to center tip slightly
              top: _pointerPosition.dy - 8,
              child: IgnorePointer(
                child: Text(
                  widget.emoji,
                  style: const TextStyle(
                    fontSize: 42,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
