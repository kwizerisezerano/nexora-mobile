// Smoke test for the Nexora Technologies mobile shell.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexora_mobile/l10n/app_strings.dart';
import 'package:nexora_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await AppStrings.load();
  });

  testWidgets('renders the Nexora shell with bottom navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NexoraApp());
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(SliverAppBar), findsWidgets);
  });
}
