import 'package:flutter/material.dart';

/// Centered icon and text for empty lists and errors, with an optional button.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            if (buttonLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onPressed,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
