import 'package:ardennes/features/drawings_catalog/recently_viewed_drawing_service.dart';
import 'package:ardennes/utils/common_firestore_collections.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ardennes/models/drawings/recently_viewed_model.dart';

void main() {
  late RecentlyViewedService service;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    // initialize FakeFirebaseFirestore
    fakeFirestore = FakeFirebaseFirestore();
    // pass the fake firestore instance to the service
    service = RecentlyViewedService(fakeFirestore);
  });

  group('RecentlyViewedService Tests', () {

    test('checkIfAlreadyViewed returns false if no record exists', () async {
      final result = await service.checkIfAlreadyViewed('user123', 'project123', 'drawing1', 'subtitle1');
      expect(result, false);
    });

    test('checkIfAlreadyViewed returns true if drawing has been viewed', () async {
      // add a mock document to FakeFirestore
      await fakeFirestore.collection(recentViews).add({
        'project_id': 'project123',
        'user_id': 'user123',
        'drawings': [
          {'title': 'drawing1', 'subtitle': 'subtitle1'}
        ]
      });

      // pass the same project, user, drawing title and subtitle to service
      final result = await service.checkIfAlreadyViewed('user123', 'project123', 'drawing1', 'subtitle1');
      expect(result, true);
    });

    test('checkIfAlreadyViewed returns false if drawing has not been viewed', () async {
      // add a mock document to FakeFirestore
      // represents currently viewed drawings for a specific project by user
      await fakeFirestore.collection(recentViews).add({
        'project_id': 'project123',
        'user_id': 'user123',
        'drawings': [
          {'title': 'drawing1', 'subtitle': 'subtitle1'}
        ]
      });

      // pass the same project, user, but different drawing title and/or subtitle to service
      final result = await service.checkIfAlreadyViewed('user123', 'project123', 'drawing2', 'subtitle3');
      expect(result, false);
    });

    test('viewDrawing adds new drawing correctly', () async {
      final view = RecentlyViewed(
        userId: 'user123',
        projectId: 'project123',
        drawing: Drawing(title: 'drawing1', subtitle: 'subtitle1', drawingThumbnailUrl: 'url'),
      );

      await service.viewDrawing(view);

      // verify the document was added to FakeFirestore
      final snapshot = await fakeFirestore.collection(recentViews).get();
      expect(snapshot.docs.isNotEmpty, true);
      final data = snapshot.docs.first.data();
      expect(data['drawings'].length, 1);
    });
  });
}
