import 'dart:math';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/circle_ring.dart';
import 'components/connection_line.dart';
import 'components/hint_highlight.dart';
import 'components/rune_node.dart';
import 'components/spell_particle_effect.dart';
import 'models/dragon_runes_config.dart';
import 'models/equation_target.dart';
import 'models/rune_node_data.dart';
import 'systems/chain_manager.dart';
import 'systems/equation_validator.dart';

/// The core Flame game class for Dragon Runes.
class DragonRunesFlameGame extends FlameGame with PanDetector {
  // -- Configuration --
  final DragonRunesConfig config;
  final List<EquationTarget> targets;
  final List<RuneNodeData> nodeData;

  // -- Callbacks to Flutter --
  final void Function(EquationResult result, List<int> chainIndices)
      onEquationValidated;
  final void Function() onLevelComplete;
  final void Function(List<String> tokens) onChainChanged;

  // -- Layout --
  late double cx, cy;
  late double cRadius;
  late double nodeRadius;
  late double snapRadius;

  // -- Game State --
  final ChainManager _chainManager = ChainManager();
  Set<String> solvedTargets = {};
  Set<String> foundCanonicals = {};
  bool _levelDone = false;

  // -- Visual State --
  List<RuneNode> nodeComponents = [];
  ConnectionLine? _activeLine;
  double _feedbackTimer = 0;
  double _shakeTimer = 0;
  double _shakeOffsetX = 0;
  double _shakeOffsetY = 0;
  Vector2? _pointerPos;

  final Random _random = Random();

  DragonRunesFlameGame({
    required this.config,
    required this.targets,
    required this.nodeData,
    required this.onEquationValidated,
    required this.onLevelComplete,
    required this.onChainChanged,
  });

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    final minDim = size.x < size.y ? size.x : size.y;
    cx = size.x / 2;
    cy = size.y / 2;
    cRadius = minDim * 0.35;
    nodeRadius = (minDim * 0.065).clamp(24.0, 36.0);
    snapRadius = nodeRadius * 1.6;

    // Add background circle ring
    add(CircleRing(cx: cx, cy: cy, radius: cRadius));

    // Create and position nodes
    _layoutNodes();

    // Add the connection line component
    _activeLine = ConnectionLine();
    add(_activeLine!);
  }

  void _layoutNodes() {
    final n = nodeData.length;
    for (int i = 0; i < n; i++) {
      final angle = (i / n) * 2 * pi - pi / 2; // start at top
      final x = cx + cos(angle) * cRadius;
      final y = cy + sin(angle) * cRadius;

      final node = RuneNode(
        data: nodeData[i],
        index: i,
        nodeRadius: nodeRadius,
      )..position = Vector2(x, y);

      nodeComponents.add(node);
      add(node);
    }
  }

  // -- Touch Handling --

  @override
  void onPanStart(DragStartInfo info) {
    if (_levelDone) return;
    final nearest = _nearestNode(info.eventPosition.widget);
    if (nearest != null) {
      _chainManager.start(nearest);
      _updateNodeStates();
      _updateConnectionLine();
      _notifyChainChanged();
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_levelDone || !_chainManager.isDragging) return;

    _pointerPos = info.eventPosition.widget;

    final nearest = _nearestNode(info.eventPosition.widget);
    if (nearest != null) {
      final action = _chainManager.extend(nearest);
      if (action != ChainAction.ignored) {
        _updateNodeStates();
        _notifyChainChanged();
      }
    }

    _updateConnectionLine();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_levelDone) return;
    _pointerPos = null;

    final chain = _chainManager.end();
    if (chain != null) {
      _validateChain(chain);
    }

    _clearChainVisuals();
    _notifyChainChanged();
  }

  int? _nearestNode(Vector2 point) {
    double minDist = snapRadius;
    int? nearest;
    for (int i = 0; i < nodeComponents.length; i++) {
      final dist = nodeComponents[i].position.distanceTo(point);
      if (dist < minDist) {
        minDist = dist;
        nearest = i;
      }
    }
    return nearest;
  }

  void _updateNodeStates() {
    // Reset all nodes to idle first
    for (final node in nodeComponents) {
      if (node.state == NodeState.inChain) {
        node.state = NodeState.idle;
      }
    }
    // Mark chain nodes
    for (final idx in _chainManager.chain) {
      nodeComponents[idx].state = NodeState.inChain;
    }
  }

  void _updateConnectionLine() {
    if (_activeLine == null) return;
    _activeLine!.points =
        _chainManager.chain.map((i) => nodeComponents[i].position).toList();
    _activeLine!.pointerPos = _pointerPos;
  }

  void _clearChainVisuals() {
    for (final node in nodeComponents) {
      if (node.state == NodeState.inChain) {
        node.state = NodeState.idle;
      }
    }
    if (_activeLine != null) {
      _activeLine!.points = [];
      _activeLine!.pointerPos = null;
    }
  }

  void _notifyChainChanged() {
    final tokens =
        _chainManager.chain.map((i) => nodeData[i].value).toList();
    onChainChanged(tokens);
  }

  // -- Validation --

  void _validateChain(List<int> chain) {
    final validator = EquationValidator(
      nodes: nodeData,
      targets: targets,
      solvedTargets: solvedTargets,
      foundCanonicals: foundCanonicals,
    );

    final result = validator.validate(chain);

    switch (result) {
      case TargetMatchEquation(:final target):
        solvedTargets.add(target.canonical);
        foundCanonicals.add(target.canonical);
        _showFeedback(chain, true);
        _spawnSpellEffect(chain);
        _checkLevelComplete();
      case BonusEquation(:final canonical):
        foundCanonicals.add(canonical);
        _showFeedback(chain, true);
        _spawnSpellEffect(chain);
      case InvalidEquation():
        _showFeedback(chain, false);
        _triggerShake();
      case AlreadyFoundEquation():
        break;
    }

    onEquationValidated(result, chain);
  }

  void _showFeedback(List<int> chainIndices, bool isCorrect) {
    final state = isCorrect ? NodeState.correct : NodeState.incorrect;
    for (final idx in chainIndices) {
      nodeComponents[idx].state = state;
    }
    _feedbackTimer = isCorrect ? 0.6 : 0.4;
  }

  void _spawnSpellEffect(List<int> chainIndices) {
    final positions =
        chainIndices.map((i) => nodeComponents[i].position).toList();
    add(SpellParticleEffect(nodePositions: positions));
  }

  void _triggerShake() {
    _shakeTimer = 0.3;
  }

  void _checkLevelComplete() {
    if (solvedTargets.length >= targets.length) {
      _levelDone = true;
      _triggerLevelCompleteCelebration();
      Future.delayed(const Duration(milliseconds: 800), () {
        onLevelComplete();
      });
    }
  }

  void _triggerLevelCompleteCelebration() {
    for (int burst = 0; burst < 5; burst++) {
      Future.delayed(Duration(milliseconds: burst * 200), () {
        if (!isMounted) return;
        final x = cx + (_random.nextDouble() - 0.5) * cRadius * 2;
        final y = cy + (_random.nextDouble() - 0.5) * cRadius * 2;
        add(SpellParticleEffect(
          nodePositions: [Vector2(x, y)],
          particleCount: 30,
        ));
      });
    }
  }

  // -- Hints --

  void showHintHighlights(List<int> nodeIndices) {
    for (final idx in nodeIndices) {
      final highlight = HintHighlight(nodeRadius: nodeRadius)
        ..position = nodeComponents[idx].position;
      add(highlight);
      nodeComponents[idx].state = NodeState.hinted;
      nodeComponents[idx].hintAnimTime = 0;
    }

    // Reset hinted state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      for (final idx in nodeIndices) {
        if (idx < nodeComponents.length &&
            nodeComponents[idx].state == NodeState.hinted) {
          nodeComponents[idx].state = NodeState.idle;
        }
      }
    });
  }

  // -- Update Loop --

  @override
  void update(double dt) {
    super.update(dt);

    // Feedback timer
    if (_feedbackTimer > 0) {
      _feedbackTimer -= dt;
      if (_feedbackTimer <= 0) {
        for (final node in nodeComponents) {
          if (node.state == NodeState.correct ||
              node.state == NodeState.incorrect) {
            node.state = NodeState.idle;
          }
        }
        // feedback cleared
      }
    }

    // Shake timer
    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      final shakeAmount = 6.0 * (_shakeTimer / 0.3);
      _shakeOffsetX = sin(_shakeTimer * 40) * shakeAmount;
      _shakeOffsetY = cos(_shakeTimer * 30) * shakeAmount * 0.5;
      if (_shakeTimer <= 0) {
        _shakeOffsetX = 0;
        _shakeOffsetY = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_shakeOffsetX != 0 || _shakeOffsetY != 0) {
      canvas.save();
      canvas.translate(_shakeOffsetX, _shakeOffsetY);
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }
}
