/// Action taken when extending the chain.
enum ChainAction { added, backtracked, ignored }

/// Manages the drag chain state and backtracking.
class ChainManager {
  List<int> chain = [];
  bool isDragging = false;

  /// Start a new chain at the given node index.
  void start(int nodeIndex) {
    chain = [nodeIndex];
    isDragging = true;
  }

  /// Try to extend the chain with a new node.
  ChainAction extend(int nodeIndex) {
    if (!isDragging || chain.isEmpty) return ChainAction.ignored;

    // Backtracking: touching previous node undoes last addition
    if (chain.length >= 2 && nodeIndex == chain[chain.length - 2]) {
      chain.removeLast();
      return ChainAction.backtracked;
    }

    // Prevent re-adding last node or any node already in chain
    if (nodeIndex == chain.last) return ChainAction.ignored;
    if (chain.contains(nodeIndex)) return ChainAction.ignored;

    chain.add(nodeIndex);
    return ChainAction.added;
  }

  /// End the chain. Returns the chain if long enough for validation.
  List<int>? end() {
    isDragging = false;
    if (chain.length >= 5) {
      final result = List<int>.from(chain);
      chain = [];
      return result;
    }
    chain = [];
    return null;
  }

  /// Clear without validation.
  void clear() {
    chain = [];
    isDragging = false;
  }

  /// Get current chain tokens as strings from node data values.
  List<String> currentTokens(List<String> nodeValues) {
    return chain.map((i) => nodeValues[i]).toList();
  }
}
