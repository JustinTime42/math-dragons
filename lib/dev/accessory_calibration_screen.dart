import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cosmetic_catalog.dart';
import '../theme/dragon_anchor_points.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';
import '../theme/dragon_rig.dart';
import '../theme/dragon_spacing.dart';

class AccessoryCalibrationScreen extends StatefulWidget {
  const AccessoryCalibrationScreen({super.key});

  @override
  State<AccessoryCalibrationScreen> createState() =>
      _AccessoryCalibrationScreenState();
}

class _AccessoryCalibrationScreenState
    extends State<AccessoryCalibrationScreen> {
  static const double _previewSize = 320;

  int _stage = 1;
  DragonRenderContext _context = DragonRenderContext.hub;
  late String _poseId;
  String _skinId = DragonRig.defaultSkinId;
  CosmeticItem _accessory = CosmeticCatalog.accessories.first;
  late AccessoryAnchor _anchor;

  @override
  void initState() {
    super.initState();
    _poseId = DragonRig.defaultPoseIdFor(_context);
    _anchor = _initialAnchor();
  }

  AccessoryAnchor _initialAnchor() {
    return DragonRig.getAccessoryAnchor(
          accessoryId: _accessory.id,
          evolutionStage: _stage,
          context: _context,
          poseId: _poseId,
        ) ??
        const AccessoryAnchor(dx: 0.5, dy: 0.5, scale: 0.3);
  }

  void _resetAnchor() {
    setState(() => _anchor = _initialAnchor());
  }

  void _updateAnchor({
    double? dx,
    double? dy,
    double? scale,
    bool? behind,
    double? rotation,
    double? rotationX,
    double? rotationY,
  }) {
    setState(() {
      _anchor = AccessoryAnchor(
        dx: dx ?? _anchor.dx,
        dy: dy ?? _anchor.dy,
        scale: scale ?? _anchor.scale,
        behind: behind ?? _anchor.behind,
        rotation: rotation ?? _anchor.rotation,
        rotationX: rotationX ?? _anchor.rotationX,
        rotationY: rotationY ?? _anchor.rotationY,
      );
    });
  }

  String get _dragonImage {
    return DragonAssets.resolveDragonImage(
      evolutionStage: _stage,
      context: _context,
      skinId: _skinId,
    );
  }

  String get _snippet => DragonRig.formatStageEntry(
    accessoryId: _accessory.id,
    evolutionStage: _stage,
    context: _context,
    anchor: _anchor,
    poseId: _poseId,
  );

  Future<void> _copySnippet() async {
    await Clipboard.setData(ClipboardData(text: _snippet));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied anchor snippet')));
  }

  @override
  Widget build(BuildContext context) {
    final canUseCurrentContext =
        DragonRig.getAccessoryAnchor(
          accessoryId: _accessory.id,
          evolutionStage: _stage,
          context: _context,
          poseId: _poseId,
        ) !=
        null;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessory Calibration')),
      backgroundColor: DragonColors.midnightBlue,
      body: SafeArea(
        child: ColoredBox(
          color: DragonColors.midnightBlue,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DragonSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Calibration Tool Loaded',
                  style: TextStyle(
                    color: DragonColors.dragonGold,
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DragonSpacing.sm),
                _buildSelectors(),
                const SizedBox(height: DragonSpacing.base),
                if (!canUseCurrentContext)
                  const _WarningBanner(
                    message:
                        'This accessory has no current anchor for this context. Adjust from the default center position.',
                  ),
                Center(child: _buildPreview()),
                const SizedBox(height: DragonSpacing.base),
                _buildControls(),
                const SizedBox(height: DragonSpacing.base),
                _buildSnippetPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DropdownShell(
          label: 'Stage',
          child: DropdownButton<int>(
            value: _stage,
            dropdownColor: DragonColors.nightSurface,
            isExpanded: true,
            style: const TextStyle(color: DragonColors.textPrimary),
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 Hatchling')),
              DropdownMenuItem(value: 2, child: Text('2 Fledgling')),
              DropdownMenuItem(value: 3, child: Text('3 Young')),
              DropdownMenuItem(value: 4, child: Text('4 Adult')),
              DropdownMenuItem(value: 5, child: Text('5 Elder')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _stage = value);
              _resetAnchor();
            },
          ),
        ),
        const SizedBox(height: DragonSpacing.sm),
        _DropdownShell(
          label: 'Context',
          child: DropdownButton<DragonRenderContext>(
            value: _context,
            dropdownColor: DragonColors.nightSurface,
            isExpanded: true,
            style: const TextStyle(color: DragonColors.textPrimary),
            items: DragonRenderContext.values
                .map(
                  (context) => DropdownMenuItem(
                    value: context,
                    child: Text(context.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _context = value;
                _poseId = DragonRig.defaultPoseIdFor(value);
              });
              _resetAnchor();
            },
          ),
        ),
        const SizedBox(height: DragonSpacing.sm),
        _DropdownShell(
          label: 'Pose',
          child: DropdownButton<String>(
            value: _poseId,
            dropdownColor: DragonColors.nightSurface,
            isExpanded: true,
            style: const TextStyle(color: DragonColors.textPrimary),
            items: _poseIdsForContext(_context)
                .map(
                  (poseId) =>
                      DropdownMenuItem(value: poseId, child: Text(poseId)),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _poseId = value);
              _resetAnchor();
            },
          ),
        ),
        const SizedBox(height: DragonSpacing.sm),
        _DropdownShell(
          label: 'Skin',
          child: DropdownButton<String>(
            value: _skinId,
            dropdownColor: DragonColors.nightSurface,
            isExpanded: true,
            style: const TextStyle(color: DragonColors.textPrimary),
            items: [
              const DropdownMenuItem(
                value: DragonRig.defaultSkinId,
                child: Text('Default'),
              ),
              for (final item in CosmeticCatalog.colors)
                DropdownMenuItem(value: item.id, child: Text(item.name)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _skinId = value);
              _resetAnchor();
            },
          ),
        ),
        const SizedBox(height: DragonSpacing.sm),
        _DropdownShell(
          label: 'Accessory',
          child: DropdownButton<CosmeticItem>(
            value: _accessory,
            dropdownColor: DragonColors.nightSurface,
            isExpanded: true,
            style: const TextStyle(color: DragonColors.textPrimary),
            items: CosmeticCatalog.accessories
                .map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.name)),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _accessory = value);
              _resetAnchor();
            },
          ),
        ),
      ],
    );
  }

  List<String> _poseIdsForContext(DragonRenderContext context) {
    switch (context) {
      case DragonRenderContext.hub:
        return const [
          DragonRig.defaultHubPoseId,
          'hub_front_3q_right',
          'hub_side_left',
          'hub_side_right',
        ];
      case DragonRenderContext.portrait:
        return const [
          DragonRig.defaultPortraitPoseId,
          'portrait_front_3q_right',
          'portrait_side_left',
          'portrait_side_right',
        ];
    }
  }

  Widget _buildPreview() {
    final dragonSize = _previewSize * 0.83;
    final accessorySize = dragonSize * _anchor.scale;
    final dragonOffset = (_previewSize - dragonSize) / 2;
    final left = dragonOffset + (_anchor.dx * dragonSize) - accessorySize / 2;
    final top = dragonOffset + (_anchor.dy * dragonSize) - accessorySize / 2;
    final accessory = _buildAccessory(accessorySize);

    return GestureDetector(
      onTapDown: (details) => _moveAnchorToLocalPosition(
        details.localPosition,
        dragonOffset,
        dragonSize,
      ),
      onPanUpdate: (details) => _nudgeAnchorByDelta(details.delta, dragonSize),
      child: Container(
        width: _previewSize,
        height: _previewSize,
        decoration: BoxDecoration(
          color: DragonColors.deepVoid.withAlpha(190),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: DragonColors.divider),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (_anchor.behind)
              Positioned(left: left, top: top, child: accessory),
            Center(
              child: Image.asset(
                _dragonImage,
                width: dragonSize,
                height: dragonSize,
                fit: BoxFit.contain,
                errorBuilder: (_, error, _) => _AssetErrorLabel(
                  label: 'Dragon asset failed\n$_dragonImage',
                  error: error,
                ),
              ),
            ),
            if (!_anchor.behind)
              Positioned(left: left, top: top, child: accessory),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CalibrationGridPainter(
                    dragonOffset: dragonOffset,
                    dragonSize: dragonSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveAnchorToLocalPosition(
    Offset localPosition,
    double dragonOffset,
    double dragonSize,
  ) {
    _updateAnchor(
      dx: ((localPosition.dx - dragonOffset) / dragonSize)
          .clamp(-0.5, 1.5)
          .toDouble(),
      dy: ((localPosition.dy - dragonOffset) / dragonSize)
          .clamp(-0.5, 1.5)
          .toDouble(),
    );
  }

  void _nudgeAnchorByDelta(Offset delta, double dragonSize) {
    _updateAnchor(
      dx: (_anchor.dx + delta.dx / dragonSize).clamp(-0.5, 1.5).toDouble(),
      dy: (_anchor.dy + delta.dy / dragonSize).clamp(-0.5, 1.5).toDouble(),
    );
  }

  Widget _buildAccessory(double accessorySize) {
    final accessoryImage = DragonAssets.resolveAccessoryImage(
      accessoryId: _accessory.id,
      evolutionStage: _stage,
      context: _context,
      skinId: _skinId == DragonRig.defaultSkinId ? null : _skinId,
    );
    final fallbackAccessoryImage = DragonAssets.resolveAccessoryImage(
      accessoryId: _accessory.id,
      evolutionStage: _stage,
      context: _context,
    );
    Widget child = Image.asset(
      accessoryImage,
      width: accessorySize,
      height: accessorySize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        fallbackAccessoryImage,
        width: accessorySize,
        height: accessorySize,
        fit: BoxFit.contain,
        errorBuilder: (_, error, _) => _AssetErrorLabel(
          label: 'Accessory asset failed\n$fallbackAccessoryImage',
          error: error,
        ),
      ),
    );
    if (_anchor.rotationX != 0 ||
        _anchor.rotationY != 0 ||
        _anchor.rotation != 0) {
      child = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateX(_anchor.rotationX)
          ..rotateY(_anchor.rotationY)
          ..rotateZ(_anchor.rotation),
        child: child,
      );
    }
    return GestureDetector(
      onPanUpdate: (details) {
        final dragonSize = _previewSize * 0.83;
        _nudgeAnchorByDelta(details.delta, dragonSize);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: DragonColors.dragonGold.withAlpha(160)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(DragonSpacing.base),
      decoration: BoxDecoration(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DragonColors.divider),
      ),
      child: Column(
        children: [
          _SliderRow(
            label: 'X',
            value: _anchor.dx,
            min: -0.2,
            max: 1.2,
            onChanged: (value) => _updateAnchor(dx: value),
          ),
          _SliderRow(
            label: 'Y',
            value: _anchor.dy,
            min: -0.3,
            max: 1.2,
            onChanged: (value) => _updateAnchor(dy: value),
          ),
          _SliderRow(
            label: 'Scale',
            value: _anchor.scale,
            min: 0.1,
            max: 0.8,
            onChanged: (value) => _updateAnchor(scale: value),
          ),
          _SliderRow(
            label: 'Tilt X',
            value: DragonRig.rotationXDegrees(_anchor),
            min: -60,
            max: 60,
            valueLabel:
                '${DragonRig.rotationXDegrees(_anchor).toStringAsFixed(1)} deg',
            onChanged: (value) =>
                _updateAnchor(rotationX: DragonRig.radiansFromDegrees(value)),
          ),
          _SliderRow(
            label: 'Tilt Y',
            value: DragonRig.rotationYDegrees(_anchor),
            min: -60,
            max: 60,
            valueLabel:
                '${DragonRig.rotationYDegrees(_anchor).toStringAsFixed(1)} deg',
            onChanged: (value) =>
                _updateAnchor(rotationY: DragonRig.radiansFromDegrees(value)),
          ),
          _SliderRow(
            label: 'Rotate Z',
            value: DragonRig.rotationDegrees(_anchor),
            min: -90,
            max: 90,
            valueLabel:
                '${DragonRig.rotationDegrees(_anchor).toStringAsFixed(1)} deg',
            onChanged: (value) =>
                _updateAnchor(rotation: DragonRig.radiansFromDegrees(value)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Render behind dragon',
              style: TextStyle(color: DragonColors.textPrimary),
            ),
            value: _anchor.behind,
            onChanged: (value) => _updateAnchor(behind: value),
          ),
          Wrap(
            spacing: DragonSpacing.sm,
            runSpacing: DragonSpacing.sm,
            children: [
              SizedBox(
                width: 132,
                child: OutlinedButton.icon(
                  onPressed: _resetAnchor,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ),
              SizedBox(
                width: 132,
                child: OutlinedButton.icon(
                  onPressed: _copySnippet,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSnippetPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DragonSpacing.base),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(120),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DragonColors.divider),
      ),
      child: SelectableText(
        _snippet,
        style: const TextStyle(
          color: DragonColors.textPrimary,
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DropdownShell extends StatelessWidget {
  final String label;
  final Widget child;

  const _DropdownShell({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DragonSpacing.sm),
      decoration: BoxDecoration(
        color: DragonColors.nightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DragonColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              label,
              style: const TextStyle(
                color: DragonColors.textSecondary,
                fontFamily: 'Nunito',
                fontSize: 11,
              ),
            ),
          ),
          DropdownButtonHideUnderline(child: child),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String? valueLabel;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: DragonColors.textPrimary),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(min, max).toDouble(),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 84,
          child: Text(
            valueLabel ?? value.toStringAsFixed(3),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: DragonColors.textSecondary,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String message;

  const _WarningBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DragonSpacing.sm),
      padding: const EdgeInsets.all(DragonSpacing.sm),
      decoration: BoxDecoration(
        color: DragonColors.fireOrange.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DragonColors.fireOrange.withAlpha(120)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: DragonColors.textPrimary),
      ),
    );
  }
}

class _AssetErrorLabel extends StatelessWidget {
  final String label;
  final Object error;

  const _AssetErrorLabel({required this.label, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(DragonSpacing.sm),
      color: DragonColors.fireOrange.withAlpha(45),
      child: Text(
        '$label\n$error',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: DragonColors.textPrimary,
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
        ),
      ),
    );
  }
}

class _CalibrationGridPainter extends CustomPainter {
  final double dragonOffset;
  final double dragonSize;

  const _CalibrationGridPainter({
    required this.dragonOffset,
    required this.dragonSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DragonColors.dragonGold.withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = Rect.fromLTWH(
      dragonOffset,
      dragonOffset,
      dragonSize,
      dragonSize,
    );
    canvas.drawRect(rect, paint);
    canvas.drawLine(rect.topCenter, rect.bottomCenter, paint);
    canvas.drawLine(rect.centerLeft, rect.centerRight, paint);
  }

  @override
  bool shouldRepaint(covariant _CalibrationGridPainter oldDelegate) {
    return oldDelegate.dragonOffset != dragonOffset ||
        oldDelegate.dragonSize != dragonSize;
  }
}
