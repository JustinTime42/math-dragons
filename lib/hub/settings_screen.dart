import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_spacing.dart';
import '../storage/local_storage.dart';
import '../core/player_profile.dart';
import '../core/audio_service.dart';
import '../models/cosmetic_catalog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _musicEnabled;
  late bool _hapticsEnabled;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final storage = context.read<LocalStorage>();
    final profile = storage.getProfile();
    _soundEnabled = profile.settings.soundEnabled;
    _musicEnabled = profile.settings.musicEnabled;
    _hapticsEnabled = profile.settings.hapticsEnabled;
    _nameController = TextEditingController(text: profile.dragonName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final storage = context.read<LocalStorage>();
    storage.updateProfile(
      (p) => p.copyWith(
        settings: PlayerSettings(
          soundEnabled: _soundEnabled,
          musicEnabled: _musicEnabled,
          hapticsEnabled: _hapticsEnabled,
        ),
      ),
    );
  }

  void _onNameChanged(String name) {
    if (name.trim().isEmpty) return;
    final storage = context.read<LocalStorage>();
    storage.updateProfile((p) => p.copyWith(dragonName: name.trim()));
  }

  /// Debug-only: put the profile in a state where every cosmetic can be tried
  /// immediately (young dragon, all cosmetics owned, plenty of scales). Used to
  /// exercise the Track A worn accessories and Track D auras in-app.
  void _grantTestLoadout() {
    final storage = context.read<LocalStorage>();
    final allIds = [
      ...CosmeticCatalog.colors,
      ...CosmeticCatalog.accessories,
      ...CosmeticCatalog.backgrounds,
      ...CosmeticCatalog.effects,
    ].map((c) => c.id).toList();
    storage.updateProfile(
      (p) => p.copyWith(
        dragonEvolution: 3,
        totalScales: p.totalScales < 5000 ? 5000 : p.totalScales,
        ownedCosmetics: {...p.ownedCosmetics, ...allIds}.toList(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test loadout granted: young dragon, all cosmetics owned'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Container(
        decoration: const BoxDecoration(gradient: DragonColors.lairGradient),
        child: ListView(
          padding: const EdgeInsets.all(DragonSpacing.base),
          children: [
            // Dragon Name Section
            _buildSectionHeader(context, l10n.dragonNameLabel),
            const SizedBox(height: DragonSpacing.sm),
            TextField(
              controller: _nameController,
              onChanged: _onNameChanged,
              style: const TextStyle(
                color: DragonColors.textPrimary,
                fontFamily: 'Nunito',
                fontSize: 16,
              ),
              maxLength: 20,
              decoration: InputDecoration(
                filled: true,
                fillColor: DragonColors.twilight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: DragonColors.amethyst),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: DragonColors.dragonGold,
                    width: 2,
                  ),
                ),
                counterStyle: const TextStyle(
                  color: DragonColors.textSecondary,
                ),
                hintText: l10n.dragonNameHint,
                hintStyle: TextStyle(
                  color: DragonColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),

            const SizedBox(height: DragonSpacing.lg),

            // Sound & Haptics Section
            _buildSectionHeader(context, l10n.settingsSoundSection),
            const SizedBox(height: DragonSpacing.sm),
            _buildToggle(
              context,
              icon: Icons.volume_up,
              title: l10n.sound,
              subtitle: l10n.soundDescription,
              value: _soundEnabled,
              onChanged: (v) {
                setState(() => _soundEnabled = v);
                _saveSettings();
                context.read<AudioService>().onSoundSettingChanged(v);
              },
            ),
            _buildToggle(
              context,
              icon: Icons.music_note,
              title: l10n.music,
              subtitle: l10n.musicDescription,
              value: _musicEnabled,
              onChanged: (v) {
                setState(() => _musicEnabled = v);
                _saveSettings();
                context.read<AudioService>().onMusicSettingChanged(v);
                if (v) {
                  context.read<AudioService>().playHubMusic();
                }
              },
            ),
            _buildToggle(
              context,
              icon: Icons.vibration,
              title: l10n.haptics,
              subtitle: l10n.hapticsDescription,
              value: _hapticsEnabled,
              onChanged: (v) {
                setState(() => _hapticsEnabled = v);
                _saveSettings();
              },
            ),

            const SizedBox(height: DragonSpacing.lg),

            if (kDebugMode) ...[
              _buildSectionHeader(context, 'Developer Tools'),
              const SizedBox(height: DragonSpacing.sm),
              _buildActionTile(
                context,
                icon: Icons.auto_awesome,
                title: 'Grant Test Loadout',
                subtitle: 'Young dragon, all cosmetics owned, 5000 scales',
                onTap: _grantTestLoadout,
              ),
              _buildActionTile(
                context,
                icon: Icons.tune,
                title: 'Accessory Calibration',
                subtitle: 'Legacy anchor tool (superseded by posed layers)',
                onTap: () =>
                    Navigator.pushNamed(context, '/dev/accessory-calibration'),
              ),
              const SizedBox(height: DragonSpacing.lg),
            ],

            // About Section
            _buildSectionHeader(context, l10n.aboutTitle),
            const SizedBox(height: DragonSpacing.sm),
            Container(
              padding: const EdgeInsets.all(DragonSpacing.base),
              decoration: BoxDecoration(
                color: DragonColors.nightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DragonColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontFamily: 'Cinzel'),
                  ),
                  const SizedBox(height: DragonSpacing.xs),
                  Text(
                    l10n.version('1.0.0'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: DragonSpacing.sm),
                  Text(
                    l10n.aboutDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: DragonColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DragonSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: DragonColors.dragonGold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DragonSpacing.xs),
      child: Material(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: SwitchListTile(
          secondary: Icon(icon, color: DragonColors.textSecondary, size: 22),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: DragonColors.nightSurface,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, color: DragonColors.textSecondary, size: 22),
        title: Text(title),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
