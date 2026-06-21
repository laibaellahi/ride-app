import 'package:flutter/material.dart';
import '../main.dart';

// ─────────────────────────────────────────────────────────────
// APP CARD
// ─────────────────────────────────────────────────────────────

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor ?? AppColors.border,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ─────────────────────────────────────────────────────────────
// ACCENT BUTTON
// ─────────────────────────────────────────────────────────────

class AccentButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool isDestructive;

  const AccentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDestructive
        ? AppColors.danger
        : (color ?? AppColors.accent);
    final fg = isDestructive ? Colors.white : AppColors.background;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: icon != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        )
            : Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 15)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CIRCLE ICON BUTTON
// ─────────────────────────────────────────────────────────────

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}