import 'dart:async';
import 'game_events.dart';

/// A simple event bus using Dart streams.
/// Games emit events. Services subscribe to specific event types.
///
/// Usage:
///   eventBus.emit(AnswerGiven(gameId: 'dragon_eggs', ...));
///   eventBus.on\<AnswerGiven\>().listen((event) { ... });
///   eventBus.stream.listen((event) { ... });
class EventBus {
  final _controller = StreamController<GameEvent>.broadcast();

  /// The raw event stream. Use [on<T>()] for typed subscriptions.
  Stream<GameEvent> get stream => _controller.stream;

  /// Subscribe to events of a specific type.
  Stream<T> on<T extends GameEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /// Emit an event to all listeners.
  void emit(GameEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Clean up. Call on app dispose.
  void dispose() {
    _controller.close();
  }
}
