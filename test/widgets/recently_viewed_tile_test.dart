import 'package:ardennes/features/home_screen/recently_drawings.dart';
import 'package:ardennes/libraries/core_ui/image_downloading/image_firebase.dart';
import 'package:ardennes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Import the generated mock class

void main() {
  group('RecentlyViewedDrawingTile Tests', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
      router = mockRouter;
    });

    testWidgets('should display title, subtitle, and image',
        (WidgetTester tester) async {
      const title = 'Drawing 123';
      const subtitle = 'Collection A';
      const drawingThumbnailUrl = 'https://example.com/drawing-thumbnail.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: RecentlyViewedDrawingTile(
            title: title,
            subtitle: subtitle,
            drawingThumbnailUrl: drawingThumbnailUrl,
          ),
        ),
      );
      // Verify the title and subtitle are displayed
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);

      // Verify the image is displayed
      expect(find.byType(ImageFromFirebase), findsOneWidget);

      final imageWidget =
          tester.widget<ImageFromFirebase>(find.byType(ImageFromFirebase));
      expect(imageWidget.imageUrl, equals(drawingThumbnailUrl));
    });

    testWidgets('should navigate to the correct URI on tap',
        (WidgetTester tester) async {
      const title = 'Drawing 123';
      const subtitle = 'Collection A';
      const drawingThumbnailUrl = 'https://example.com/drawing-thumbnail.png';

      // we will need this for verification
      var url = Uri(
        path: '/drawings/sheet',
        queryParameters: {
          'number': title,
          'collection': subtitle,
          'versionId': "0",
        },
      ).toString();

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: mockRouter,
          builder: (context, w) {
            return const RecentlyViewedDrawingTile(
              title: title,
              subtitle: subtitle,
              drawingThumbnailUrl: drawingThumbnailUrl,
            );
          },
        ),
      );
      // Tap the widget
      await tester.tap(find.byType(RecentlyViewedDrawingTile));
      // if go was called with the parameters passed to RecentlyViewedDrawingTile, then onTap works as expected
      verify(mockRouter.go(url)).called(1);
    });
  });
}
