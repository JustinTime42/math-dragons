import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../core/player_profile.dart';
import '../models/cosmetic_catalog.dart';
import '../storage/local_storage.dart';
import '../theme/dragon_anchor_points.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../widgets/cosmetic_preview.dart';

/// Full-screen dragon customization screen.
/// Lets the player equip owned colors and accessories.
class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  late PlayerProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = context.read<LocalStorage>().getProfile();
  }

  LocalStorage get _storage => context.read<LocalStorage>();

  void _equipColor(String? colorId) {
    // Tap same color again to unequip
    final unequip = _profile.equippedColor == colorId;
    if (unequip) {
      // copyWith can't set nullable fields to null, so reconstruct
      _storage.updateProfile(
        (p) => PlayerProfile(
          id: p.id,
          dragonName: p.dragonName,
          dragonEvolution: p.dragonEvolution,
          totalScales: p.totalScales,
          totalCorrectAnswers: p.totalCorrectAnswers,
          totalPlayTimeMinutes: p.totalPlayTimeMinutes,
          dailyChallengeStreak: p.dailyChallengeStreak,
          createdAt: p.createdAt,
          lastPlayedAt: p.lastPlayedAt,
          gameStats: p.gameStats,
          settings: p.settings,
          ownedCosmetics: p.ownedCosmetics,
          equippedColor: null,
          equippedAccessories: p.equippedAccessories,
          schemaVersion: p.schemaVersion,
          isFirstSession: p.isFirstSession,
          ageGroup: p.ageGroup,
          firebaseUid: p.firebaseUid,
          linkedProvider: p.linkedProvider,
        ),
      );
    } else {
      _storage.updateProfile((p) => p.copyWith(equippedColor: colorId));
    }
    setState(() => _profile = _storage.getProfile());
  }

  /// Toggle an equipped-list cosmetic (accessory or aura effect). Slot and
  /// single-aura rules are enforced by [CosmeticCatalog.toggleEquipped].
  void _toggleEquipped(String cosmeticId) {
    final item = CosmeticCatalog.findById(cosmeticId);
    if (item == null) return;
    final next = CosmeticCatalog.toggleEquipped(
      _profile.equippedAccessories,
      item,
    );
    _storage.updateProfile((p) => p.copyWith(equippedAccessories: next));
    setState(() => _profile = _storage.getProfile());
  }

  void _equipBackground(String? bgId) {
    // Tap same background again to unequip
    final unequip = _profile.equippedBackground == bgId;
    if (unequip) {
      // copyWith can't set nullable fields to null, so reconstruct
      _storage.updateProfile(
        (p) => PlayerProfile(
          id: p.id,
          dragonName: p.dragonName,
          dragonEvolution: p.dragonEvolution,
          totalScales: p.totalScales,
          totalCorrectAnswers: p.totalCorrectAnswers,
          totalPlayTimeMinutes: p.totalPlayTimeMinutes,
          dailyChallengeStreak: p.dailyChallengeStreak,
          createdAt: p.createdAt,
          lastPlayedAt: p.lastPlayedAt,
          gameStats: p.gameStats,
          settings: p.settings,
          ownedCosmetics: p.ownedCosmetics,
          equippedColor: p.equippedColor,
          equippedAccessories: p.equippedAccessories,
          schemaVersion: p.schemaVersion,
          isFirstSession: p.isFirstSession,
          ageGroup: p.ageGroup,
          firebaseUid: p.firebaseUid,
          linkedProvider: p.linkedProvider,
          equippedBackground: null,
        ),
      );
    } else {
      _storage.updateProfile((p) => p.copyWith(equippedBackground: bgId));
    }
    setState(() => _profile = _storage.getProfile());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ownedColors = CosmeticCatalog.colors
        .where((c) => _profile.ownedCosmetics.contains(c.id))
        .toList();
    final ownedAccessories = CosmeticCatalog.accessories
        .where((a) => _profile.ownedCosmetics.contains(a.id))
        .toList();
    final ownedBackgrounds = CosmeticCatalog.backgrounds
        .where((b) => _profile.ownedCosmetics.contains(b.id))
        .toList();
    final ownedEffects = CosmeticCatalog.effects
        .where((e) => _profile.ownedCosmetics.contains(e.id))
        .toList();
    final hasAnything =
        ownedColors.isNotEmpty ||
        ownedAccessories.isNotEmpty ||
        ownedBackgrounds.isNotEmpty ||
        ownedEffects.isNotEmpty;

    return Scaffold(
      backgroundColor: DragonColors.midnightBlue,
      appBar: AppBar(
        title: Text(l10n.customizeDragon),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(DragonSpacing.base),
        children: [
          // Dragon preview with background
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: _profile.equippedBackground != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          DragonAssets.backgroundImages[_profile
                                  .equippedBackground!] ??
                              DragonAssets.gameBackgrounds['dragon_eggs']!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(
                      color: DragonColors.midnightBlue,
                      boxShadow: [
                        BoxShadow(
                          color: DragonColors.dragonGold.withValues(alpha: 0.2),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
              child: Center(
                child: CosmeticPreview(
                  evolutionStage: _profile.dragonEvolution,
                  equippedColorId: _profile.equippedColor,
                  equippedAccessoryIds: _profile.equippedAccessories,
                  useHubImage: true,
                  size: 160,
                ),
              ),
            ),
          ),

          const SizedBox(height: DragonSpacing.lg),

          if (!hasAnything) ...[
            // Empty wardrobe state
            Center(
              child: Column(
                children: [
                  const SizedBox(height: DragonSpacing.xl),
                  const Icon(Icons.checkroom, color: Colors.white24, size: 64),
                  const SizedBox(height: DragonSpacing.base),
                  Text(
                    l10n.emptyWardrobe,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: DragonSpacing.sm),
                  Text(
                    l10n.emptyWardrobeHint,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white38),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            // Colors section
            if (ownedColors.isNotEmpty) ...[
              _SectionLabel(title: l10n.dragonColors),
              const SizedBox(height: DragonSpacing.sm),
              _buildColorGrid(ownedColors),
              const SizedBox(height: DragonSpacing.lg),
            ],

            // Accessories section
            if (ownedAccessories.isNotEmpty) ...[
              _SectionLabel(title: l10n.dragonAccessories),
              const SizedBox(height: DragonSpacing.sm),
              _buildAccessoryGrid(ownedAccessories),
              const SizedBox(height: DragonSpacing.lg),
            ],

            // Aura effects section
            if (ownedEffects.isNotEmpty) ...[
              const _SectionLabel(title: 'Aura Effects'),
              const SizedBox(height: DragonSpacing.sm),
              _buildEffectGrid(ownedEffects),
              const SizedBox(height: DragonSpacing.lg),
            ],

            // Backgrounds section
            if (ownedBackgrounds.isNotEmpty) ...[
              const _SectionLabel(title: 'Backgrounds'),
              const SizedBox(height: DragonSpacing.sm),
              _buildBackgroundGrid(ownedBackgrounds),
              const SizedBox(height: DragonSpacing.lg),
            ],
          ],

          // Visit Store button
          const SizedBox(height: DragonSpacing.base),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/store'),
              icon: const Icon(Icons.store, size: 18),
              label: Text(l10n.visitStore),
              style: OutlinedButton.styleFrom(
                foregroundColor: DragonColors.amethyst,
                side: const BorderSide(color: DragonColors.amethyst),
                padding: const EdgeInsets.symmetric(
                  horizontal: DragonSpacing.lg,
                  vertical: DragonSpacing.sm,
                ),
              ),
            ),
          ),

          const SizedBox(height: DragonSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildColorGrid(List<CosmeticItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final equipped = _profile.equippedColor == item.id;
        return _EquipTile(
          item: item,
          equipped: equipped,
          previewSkinId: _profile.equippedColor,
          previewStage: _profile.dragonEvolution,
          onTap: () => _equipColor(item.id),
        );
      },
    );
  }

  Widget _buildAccessoryGrid(List<CosmeticItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final equipped = _profile.equippedAccessories.contains(item.id);
        return _EquipTile(
          item: item,
          equipped: equipped,
          previewSkinId: _profile.equippedColor,
          previewStage: _profile.dragonEvolution,
          onTap: () => _toggleEquipped(item.id),
        );
      },
    );
  }

  Widget _buildEffectGrid(List<CosmeticItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final equipped = _profile.equippedAccessories.contains(item.id);
        return _EquipTile(
          item: item,
          equipped: equipped,
          previewSkinId: _profile.equippedColor,
          previewStage: _profile.dragonEvolution,
          onTap: () => _toggleEquipped(item.id),
        );
      },
    );
  }

  Widget _buildBackgroundGrid(List<CosmeticItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final equipped = _profile.equippedBackground == item.id;
        return _EquipTile(
          item: item,
          equipped: equipped,
          previewSkinId: _profile.equippedColor,
          previewStage: _profile.dragonEvolution,
          onTap: () => _equipBackground(item.id),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: Colors.white),
    );
  }
}

class _EquipTile extends StatelessWidget {
  final CosmeticItem item;
  final bool equipped;
  final String? previewSkinId;
  final int previewStage;
  final VoidCallback onTap;

  const _EquipTile({
    required this.item,
    required this.equipped,
    required this.previewSkinId,
    required this.previewStage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: DragonColors.nightSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: equipped ? DragonColors.dragonGold : Colors.transparent,
            width: equipped ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPreview(),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: equipped ? DragonColors.dragonGold : Colors.white70,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    // Accessory tiles show the standalone item icon (item.imagePath), not the
    // dragon wearing it — the tiles are too small to read the worn detail.
    final previewImage = _previewImageFor(item);
    if (previewImage != null) {
      return Image.asset(
        previewImage,
        width: 36,
        height: 36,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: item.previewColor ?? Colors.white12,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(item.previewEmoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  String? _previewImageFor(CosmeticItem item) {
    switch (item.type) {
      case CosmeticType.color:
        return DragonAssets.resolveDragonImage(
          evolutionStage: 3,
          context: DragonRenderContext.portrait,
          skinId: item.id,
        );
      case CosmeticType.accessory:
        return item.imagePath;
      case CosmeticType.background:
        return item.imagePath;
      case CosmeticType.effect:
        // Code-drawn aura; shown via previewColor + emoji fallback.
        return null;
    }
  }
}
