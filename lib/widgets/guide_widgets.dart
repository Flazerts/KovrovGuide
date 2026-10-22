import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Музеи':
      return Icons.account_balance_rounded;
    case 'Памятники':
      return Icons.account_balance_outlined;
    case 'Парки':
      return Icons.park_rounded;
    case 'История':
      return Icons.history_edu_rounded;
    default:
      return Icons.place_rounded;
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeading({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ])),
          if (trailing != null) trailing!,
        ]),
      );
}

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.w800, color: GuideColors.green));
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;
  const EmptyState({super.key, required this.icon, required this.title, required this.body, this.action});

  @override
  Widget build(BuildContext context) => Center(child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 72, height: 72, decoration: const BoxDecoration(color: GuideColors.mint, shape: BoxShape.circle), child: Icon(icon, color: GuideColors.green, size: 32)),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(body, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ]),
      ));
}

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final bool compact;
  final bool showPlanAction;
  final VoidCallback? onPlanAction;
  const PlaceCard({super.key, required this.place, required this.onTap, this.compact = false, this.showPlanAction = false, this.onPlanAction});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final isFavorite = AppState.instance.isFavorite(place.id);
          final isInPlan = AppState.instance.isInPlan(place.id);
          final imageWidth = compact ? 55.0 : 65.0;
          final imageHeight = compact ? 58.0 : 70.0;

          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(compact ? 12 : 15),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: imageWidth,
                    height: imageHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: GuideColors.mint,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: place.imageUrl != null
                          ? Image.asset(
                              place.imageUrl!,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Text(place.emoji, style: TextStyle(fontSize: compact ? 27 : 31)),
                            )
                          : Text(place.emoji, style: TextStyle(fontSize: compact ? 27 : 31)),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(place.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 14 : 15, fontWeight: FontWeight.w700, height: 1.25, color: GuideColors.ink))),
                      IconButton(
                        tooltip: isFavorite ? 'Убрать из избранного' : 'В избранное',
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        onPressed: () => AppState.instance.toggleFavorite(place.id),
                        icon: Icon(isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: isFavorite ? GuideColors.green : GuideColors.muted, size: 22),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(place.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 9),
                    Wrap(spacing: 6, runSpacing: 5, children: [
                      _SmallTag(text: place.category),
                      if (place.status != null) const _SmallTag(text: 'Уточнить статус', warning: true),
                    ]),
                    if (showPlanAction) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: onPlanAction,
                          icon: Icon(isInPlan ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, size: 18),
                          label: Text(isInPlan ? 'В маршруте' : 'Добавить в маршрут'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isInPlan ? GuideColors.greenDark : GuideColors.green,
                            side: BorderSide(color: isInPlan ? GuideColors.green : GuideColors.line),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                    ],
                  ])),
                ]),
              ),
            ),
          );
        },
      );
}

class _SmallTag extends StatelessWidget {
  final String text;
  final bool warning;
  const _SmallTag({required this.text, this.warning = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: warning ? GuideColors.warningBg : GuideColors.paper, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: warning ? GuideColors.warning : GuideColors.muted)),
      );
}

class PrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const PrimaryAction({super.key, required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(backgroundColor: GuideColors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      );
}