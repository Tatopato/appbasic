import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/anime_catalog.dart';
import '../services/user_data_service.dart';

/// Clean, light, minimal look shared by Home / Search / Profile:
/// off-white background, white cards with hairline borders, one accent color.

class Mi {
  Mi._();

  static const Color bg = Color(0xFFF7F7F9);
  static const Color surface = Colors.white;
  static const Color line = Color(0xFFECECF1);
  static const Color text = Color(0xFF1C1C1E);
  static const Color sub = Color(0xFF8E8E93);
  static const Color accent = Color(0xFFFF4D94);
  static const Color danger = Color(0xFFE5484D);

  static TextStyle title({double size = 26}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: text,
        height: 1.2,
      );

  static TextStyle section() => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: text,
      );

  static TextStyle body({
    double size = 14,
    Color color = text,
    FontWeight weight = FontWeight.w500,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  static TextStyle caption() => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: sub,
      );

  static BoxDecoration card({double radius = 18}) => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: line),
      );
}

String timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${time.day}/${time.month}/${time.year}';
}

void miSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Mi.text,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message, style: Mi.body(color: Colors.white)),
      ),
    );
}

// ---------------------------------------------------------------------------
// Header / empty / error
// ---------------------------------------------------------------------------

class MiSectionHeader extends StatelessWidget {
  const MiSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Mi.section())),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: Mi.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel!,
              style: Mi.body(size: 13, color: Mi.accent, weight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class MiEmpty extends StatelessWidget {
  const MiEmpty({
    super.key,
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: Mi.card(),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Mi.sub),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Mi.body(color: Mi.sub),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: Mi.accent,
                side: const BorderSide(color: Mi.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                actionLabel!,
                style: Mi.body(color: Mi.accent, weight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MiLoading extends StatelessWidget {
  const MiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: Mi.accent),
        ),
      ),
    );
  }
}

/// Shown when a Firestore stream fails (usually: Firestore not enabled yet,
/// or the security rules haven't been deployed).
class MiDataError extends StatelessWidget {
  const MiDataError({super.key});

  @override
  Widget build(BuildContext context) {
    return const MiEmpty(
      icon: Icons.cloud_off_rounded,
      text: "Can't load your data.\n"
          'Check that Firestore is enabled and the rules are deployed.',
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar
// ---------------------------------------------------------------------------

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.profile, this.size = 44});

  final UserProfile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = profile.displayName.isEmpty
        ? '?'
        : profile.displayName.characters.first.toUpperCase();

    final fallback = Container(
      color: Mi.accent.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: size * 0.42,
          fontWeight: FontWeight.w800,
          color: Mi.accent,
        ),
      ),
    );

    Widget image = fallback;
    if (profile.avatar != null) {
      image = Image.asset(
        profile.avatar!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    } else if (profile.photoUrl != null) {
      image = Image.network(
        profile.photoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(child: image),
    );
  }
}

// ---------------------------------------------------------------------------
// Anime poster tile + detail sheet
// ---------------------------------------------------------------------------

Future<void> toggleFavorite(
  BuildContext context,
  Anime anime,
  bool currentlyFavorite,
) async {
  try {
    await UserDataService.instance.setFavorite(anime.id, !currentlyFavorite);
  } catch (_) {
    if (context.mounted) {
      miSnack(context, "Couldn't update favorites. Please try again.");
    }
  }
}

class AnimeTile extends StatelessWidget {
  const AnimeTile({super.key, required this.anime, required this.isFavorite});

  final Anime anime;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showAnimeSheet(context, anime),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    anime.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Mi.line),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(context, anime, isFavorite),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite ? Mi.accent : Mi.sub,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            anime.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Mi.body(size: 13, weight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            anime.genreLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Mi.caption(),
          ),
        ],
      ),
    );
  }
}

Future<void> showAnimeSheet(BuildContext context, Anime anime) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Mi.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _AnimeSheet(anime: anime),
  );
}

class _AnimeSheet extends StatefulWidget {
  const _AnimeSheet({required this.anime});

  final Anime anime;

  @override
  State<_AnimeSheet> createState() => _AnimeSheetState();
}

class _AnimeSheetState extends State<_AnimeSheet> {
  late final Stream<Set<String>> _favorites =
      UserDataService.instance.favoriteIdsStream();

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                anime.image,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 100, height: 150, color: Mi.line),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.title, style: Mi.title(size: 18)),
                  const SizedBox(height: 6),
                  Text(anime.genreLabel, style: Mi.caption()),
                  const SizedBox(height: 18),
                  StreamBuilder<Set<String>>(
                    stream: _favorites,
                    builder: (context, snapshot) {
                      final isFav = snapshot.data?.contains(anime.id) ?? false;
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: snapshot.hasData
                              ? () => toggleFavorite(context, anime, isFav)
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: isFav ? Mi.line : Mi.accent,
                            foregroundColor: isFav ? Mi.text : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18,
                          ),
                          label: Text(
                            isFav ? 'In favorites' : 'Add to favorites',
                            style: Mi.body(
                              color: isFav ? Mi.text : Colors.white,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
