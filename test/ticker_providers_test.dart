import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ticker/models/tick.dart';
import 'package:riverpod_ticker/providers/ticker_providers.dart';
import 'package:riverpod_ticker/services/tick_feed.dart';

void main() {
  test('tickerProvider emits ticks from the configured feed', () async {
    final ticks = [
      Tick(
        symbol: 'BTC',
        price: 67234.56,
        change: 12.34,
        at: DateTime.utc(2026, 10, 21),
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        tickFeedProvider.overrideWithValue(_FakeTickFeed(ticks)),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(tickerProvider, (_, _) {});
    addTearDown(subscription.close);

    await expectLater(container.read(tickerProvider.future), completion(ticks));
  });
}

class _FakeTickFeed extends TickFeed {
  _FakeTickFeed(this.ticks) : super(symbols: const []);

  final List<Tick> ticks;

  @override
  Stream<List<Tick>> watch() => Stream.value(ticks);
}