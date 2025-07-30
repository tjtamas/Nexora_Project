import 'package:flutter/material.dart';

class AdminActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const AdminActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.blue,
  });

  @override
  State<AdminActionButton> createState() => _AdminActionButtonState();
}

class _AdminActionButtonState extends State<AdminActionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed
        ? 0.95
        : _isHovered
            ? 1.03
            : 1.0;

    final shadow = _isHovered
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(2, 4),
            )
          ];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: shadow,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(widget.icon, size: 28, color: widget.color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
