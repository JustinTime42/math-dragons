import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/player_profile.dart';
import '../models/cosmetic_catalog.dart';
import '../storage/local_storage.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';

/// Cosmetics store screen for spending Dragon Scales.
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();

    return Scaffold(
      backgroundColor: DragonColors.midnightBlue,
      appBar: AppBar(
        title: const Text('Dragon Store'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DragonSpacing.base),
            child: Center(
              child: Row(
                children: [
                  Image.asset(DragonAssets.iconScale, width: 18, height: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.totalScales}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: DragonColors.dragonGold,
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(DragonSpacing.base),
        children: [
          // IAP section placeholder (Step 11)
          const _SectionHeader(
              title: 'Premium Packs', subtitle: 'Coming in a future update'),
          const SizedBox(height: DragonSpacing.lg),

          // Dragon Colors section
          const _SectionHeader(
              title: 'Dragon Colors', subtitle: 'Customize your dragon'),
          const SizedBox(height: DragonSpacing.sm),
          _CosmeticGrid(
            items: CosmeticCatalog.colors,
            profile: profile,
            storage: storage,
          ),
          const SizedBox(height: DragonSpacing.lg),

          // Backgrounds section
          const _SectionHeader(
              title: 'Backgrounds', subtitle: 'Customize your lair'),
          const SizedBox(height: DragonSpacing.sm),
          _CosmeticGrid(
            items: CosmeticCatalog.backgrounds,
            profile: profile,
            storage: storage,
          ),
          // TODO: Re-enable Accessories section when ready
          // const _SectionHeader(
          //     title: 'Accessories', subtitle: 'Style your dragon'),
          // const SizedBox(height: DragonSpacing.sm),
          // _CosmeticGrid(
          //   items: CosmeticCatalog.accessories,
          //   profile: profile,
          //   storage: storage,
          // ),
          const SizedBox(height: DragonSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
        ),
      ],
    );
  }
}

class _CosmeticGrid extends StatefulWidget {
  final List<CosmeticItem> items;
  final PlayerProfile profile;
  final LocalStorage storage;

  const _CosmeticGrid({
    required this.items,
    required this.profile,
    required this.storage,
  });

  @override
  State<_CosmeticGrid> createState() => _CosmeticGridState();
}

class _CosmeticGridState extends State<_CosmeticGrid> {
  late PlayerProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  void _purchase(CosmeticItem item) {
    if (_profile.totalScales < item.cost) return;
    if (_profile.ownedCosmetics.contains(item.id)) return;

    widget.storage.updateProfile((p) => p.copyWith(
          totalScales: p.totalScales - item.cost,
          ownedCosmetics: [...p.ownedCosmetics, item.id],
        ));
    setState(() => _profile = widget.storage.getProfile());
  }

  void _equip(CosmeticItem item) {
    if (!_profile.ownedCosmetics.contains(item.id)) return;

    if (item.type == CosmeticType.color) {
      widget.storage
          .updateProfile((p) => p.copyWith(equippedColor: item.id));
    } else if (item.type == CosmeticType.background) {
      widget.storage
          .updateProfile((p) => p.copyWith(equippedBackground: item.id));
    } else {
      final current = List<String>.from(_profile.equippedAccessories);
      if (current.contains(item.id)) {
        current.remove(item.id);
      } else {
        // Remove any other accessory in the same slot
        if (item.slot != null) {
          current.removeWhere((id) {
            final other = CosmeticCatalog.findById(id);
            return other?.slot == item.slot;
          });
        }
        current.add(item.id);
      }
      widget.storage
          .updateProfile((p) => p.copyWith(equippedAccessories: current));
    }
    setState(() => _profile = widget.storage.getProfile());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: DragonSpacing.sm,
        crossAxisSpacing: DragonSpacing.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final owned = _profile.ownedCosmetics.contains(item.id);
        final equipped = item.type == CosmeticType.color
            ? _profile.equippedColor == item.id
            : item.type == CosmeticType.background
                ? _profile.equippedBackground == item.id
                : _profile.equippedAccessories.contains(item.id);
        final canAfford = _profile.totalScales >= item.cost;

        return _CosmeticTile(
          item: item,
          owned: owned,
          equipped: equipped,
          canAfford: canAfford,
          onTap: owned
              ? () => _equip(item)
              : (canAfford ? () => _purchase(item) : null),
        );
      },
    );
  }
}

class _CosmeticTile extends StatelessWidget {
  final CosmeticItem item;
  final bool owned;
  final bool equipped;
  final bool canAfford;
  final VoidCallback? onTap;

  const _CosmeticTile({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.canAfford,
    this.onTap,
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
            color: equipped
                ? DragonColors.dragonGold
                : (owned
                    ? DragonColors.emeraldFlame.withAlpha(80)
                    : Colors.transparent),
            width: equipped ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Preview
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.imagePath != null
                    ? Colors.white.withAlpha(10)
                    : (item.previewColor ?? Colors.white12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: item.imagePath != null
                    ? Image.asset(
                        item.imagePath!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      )
                    : Text(item.previewEmoji,
                        style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: DragonSpacing.xs),
            Text(
              item.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            if (equipped)
              Text(
                'Equipped',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DragonColors.dragonGold,
                      fontSize: 10,
                    ),
              )
            else if (owned)
              Text(
                'Owned',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DragonColors.emeraldFlame,
                      fontSize: 10,
                    ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: canAfford ? 1.0 : 0.3,
                    child: Image.asset(DragonAssets.iconScale, width: 10, height: 10),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${item.cost}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: canAfford
                              ? DragonColors.dragonGold
                              : Colors.white24,
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
