import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nasa_satellite/presentation/widgets/card_tile_item.dart';

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  group('CardTileItem', () {
    testWidgets('renders image, title, and date', (WidgetTester tester) async {
      // Arrange
      final mockOnTap = MockVoidCallback();
      const imageUrl = 'https://nasasatellite.com/image.jpg';
      const title = 'Title';
      const date = 'Date';

      // Act
      await tester.pumpWidget(MaterialApp(
        home: CardTileItem(
          imageUrl: imageUrl,
          title: title,
          date: date,
          onTap: mockOnTap,
        ),
      ));

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(date), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      // Arrange
      final mockOnTap = MockVoidCallback();
      const imageUrl = 'https://nasasatellite.com/image.jpg';
      const title = 'Title';
      const date = 'Date';

      // Act
      await tester.pumpWidget(MaterialApp(
        home: CardTileItem(
          imageUrl: imageUrl,
          title: title,
          date: date,
          onTap: mockOnTap,
        ),
      ));
      await tester.tap(find.byType(GestureDetector));

      // Assert
      verify(mockOnTap()).called(1);
    });
  });
}
