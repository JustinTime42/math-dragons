import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_dragons/l10n/app_localizations.dart';

import '../theme/dragon_colors.dart';

/// A two-digit by two-digit multiplication problem a young child can't solve
/// in their head (design: docs/MOBILE_APP_PLAN.md, "Purchase Safeguards").
class ParentalGateChallenge {
  final int a;
  final int b;

  const ParentalGateChallenge(this.a, this.b);

  int get answer => a * b;

  /// Both factors in 13..29 and never a multiple of 10, so there are no
  /// shortcut products like 20 x 15.
  factory ParentalGateChallenge.generate(Random random) {
    int pick() {
      while (true) {
        final n = 13 + random.nextInt(17);
        if (n % 10 != 0) return n;
      }
    }

    return ParentalGateChallenge(pick(), pick());
  }

  bool check(String input) => int.tryParse(input.trim()) == answer;
}

/// Shows the grown-ups-only gate. Resolves to true only if the answer is
/// correct; cancel or a wrong answer resolves to false.
class ParentalGate {
  static Future<bool> show(BuildContext context, {Random? random}) async {
    final challenge = ParentalGateChallenge.generate(random ?? Random());
    final passed = await showDialog<bool>(
      context: context,
      builder: (_) => ParentalGateDialog(challenge: challenge),
    );
    return passed ?? false;
  }
}

class ParentalGateDialog extends StatefulWidget {
  final ParentalGateChallenge challenge;

  const ParentalGateDialog({super.key, required this.challenge});

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  final _controller = TextEditingController();
  bool _wrong = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.challenge.check(_controller.text)) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _wrong = true);
      // One try per challenge, so it can't be brute-forced by guessing.
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) Navigator.of(context).pop(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = widget.challenge;
    return AlertDialog(
      title: Text(l10n.parentalGateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.parentalGateQuestion(c.a, c.b)),
          const SizedBox(height: 12),
          TextField(
            key: const Key('parental_gate_input'),
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (_) => _submit(),
          ),
          if (_wrong) ...[
            const SizedBox(height: 8),
            Text(
              l10n.parentalGateWrong,
              style: const TextStyle(color: DragonColors.textSecondary),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          key: const Key('parental_gate_submit'),
          onPressed: _wrong ? null : _submit,
          child: Text(l10n.parentalGateContinue),
        ),
      ],
    );
  }
}
