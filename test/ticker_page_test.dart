import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_ticker/models/tick.dart';
import 'package:riverpod_ticker/providers/ticker_providers.dart';
import 'package:riverpod_ticker/ticker_page.dart';

void main() {
  final tick = Tick(
    symbol: 'BTC',
    price: 67234.56,
    change: 12.34,
    at: DateTime.utc(2026, 10, 21),
  );

  testWidgets('shows ticks from the ticker provider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) => Stream.value([tick])),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('67234.56'), findsOneWidget);
    expect(find.text('+12.34'), findsOneWidget);
  });

  testWidgets('shows a loading indicator while waiting for ticks', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a message when the ticker provider fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tickerProvider.overrideWith(
            (ref) => Stream.error(Exception('Feed disconnected')),
          ),
        ],
        child: const MaterialApp(home: TickerPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Feed disconnected'), findsOneWidget);
  });
}