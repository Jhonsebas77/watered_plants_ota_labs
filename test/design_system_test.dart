import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:watered_plants_ota_labs/core/enums/enums.dart';
import 'package:watered_plants_ota_labs/core/utils/utils.dart';
import 'package:watered_plants_ota_labs/ui/theme/theme.dart';
import 'package:watered_plants_ota_labs/ui/widgets/widgets.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: appDarkTheme,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  group('BlueprintPrimaryButton', () {
    testWidgets('shows label and icon when idle', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrap(
          BlueprintPrimaryButton(
            label: 'REGAR PLANTA',
            icon: Icons.local_drink_rounded,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('REGAR PLANTA'), findsOneWidget);
      expect(find.byIcon(Icons.local_drink_rounded), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner and is disabled while loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          BlueprintPrimaryButton(
            label: 'REGAR PLANTA',
            loading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('REGAR PLANTA'), findsNothing);
      ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('CountdownChip', () {
    DateTime now = DateTime(2026, 9, 28, 15);

    Future<void> pumpChip(WidgetTester tester, DateTime next) => tester
        .pumpWidget(_wrap(CountdownChip(nextWateringDate: next, now: now)));

    Color labelColor(WidgetTester tester, String label) =>
        tester.widget<Text>(find.text(label)).style!.color!;

    testWidgets('today is a warning', (WidgetTester tester) async {
      await pumpChip(tester, DateTime(2026, 9, 28));
      expect(labelColor(tester, 'Regar hoy'), BlueprintColors.warning);
    });

    testWidgets('tomorrow is a warning', (WidgetTester tester) async {
      await pumpChip(tester, DateTime(2026, 9, 29));
      expect(labelColor(tester, 'Regar mañana'), BlueprintColors.warning);
    });

    testWidgets('future days are ok', (WidgetTester tester) async {
      await pumpChip(tester, DateTime(2026, 10, 3));
      expect(labelColor(tester, 'Regar en 5d'), BlueprintColors.successGreen);
    });

    testWidgets('overdue is danger', (WidgetTester tester) async {
      await pumpChip(tester, DateTime(2026, 9, 25));
      expect(labelColor(tester, 'Atrasada 3d'), BlueprintColors.danger);
    });
  });

  group('wateringLevel', () {
    DateTime today = DateTime.now();

    test('maps day offsets to traffic light levels', () {
      expect(wateringLevel(toYYYYMMdd(today)), TrafficLightLevel.warning);
      expect(
        wateringLevel(toYYYYMMdd(today.add(const Duration(days: 3)))),
        TrafficLightLevel.ok,
      );
      expect(
        wateringLevel(toYYYYMMdd(today.subtract(const Duration(days: 2)))),
        TrafficLightLevel.danger,
      );
    });

    test('returns null and a muted color for invalid dates', () {
      expect(wateringLevel('not-a-date'), isNull);
      expect(wateringStatusColor('not-a-date'), BlueprintColors.textMuted);
    });
  });
}
