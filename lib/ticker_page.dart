import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/ticker_providers.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ticker')),
      body: ticks.when(
        data: (ticks) => ListView.builder(
          itemCount: ticks.length,
          itemBuilder: (context, index) {
            final tick = ticks[index];
            final changeColor = tick.isUp ? Colors.green : Colors.red;

            return ListTile(
              title: Text(tick.symbol),
              subtitle: Text(tick.at.toLocal().toString()),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(tick.price.toStringAsFixed(2)),
                  Text(
                    '${tick.change >= 0 ? '+' : ''}${tick.change.toStringAsFixed(2)}',
                    style: TextStyle(color: changeColor),
                  ),
                ],
              ),
            );
          },
        ),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load ticker: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}