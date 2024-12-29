import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart';
import 'package:ardennes/features/drawings_catalog/drawings_catalog_event.dart';
import 'package:ardennes/libraries/drawing/drawing_catalog_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'recently_viewed_bloc_test.mocks.mocks.dart'; // Import generated mocks

void main() {
  late MockRecentlyViewedService mockRecentlyViewedService;
  late DrawingsCatalogBloc bloc;

  setUp(() {
    mockRecentlyViewedService = MockRecentlyViewedService();
    //no need to mock this service, it is not being used.
    var dcs = DrawingCatalogService();
    bloc = DrawingsCatalogBloc(dcs, mockRecentlyViewedService);
  });

  test('should call viewDrawing when user has not viewed the drawing', () async {
    // make check function return false
    when(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).thenAnswer((_) async => false);

    when(mockRecentlyViewedService.viewDrawing(any)).thenAnswer((_) async {});

    // trigger event
    bloc.add(ViewDrawingEvent( 'project123','user123','Title','Subtitle','thumbnail',
    ));

    // ensure async code runs
    await Future.delayed(Duration.zero);

    // verify check function is called, and only once
    verify(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).called(1);

    // verify view function is called and only once
    verify(mockRecentlyViewedService.viewDrawing(any)).called(1);
  });

  test('should not call viewDrawing when user has already viewed the drawing', () async {
    // make check return true
    when(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).thenAnswer((_) async => true); // Simulate user has already viewed

    // trigger event
    bloc.add(ViewDrawingEvent( 'project123','user123','Title','Subtitle','thumbnail',
    ));

    // ensure async code runs
    await Future.delayed(Duration.zero);

    // verify check if called and only once
    verify(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).called(1);

    //verify view is never called
    verifyNever(mockRecentlyViewedService.viewDrawing(any));
  });

  test('should exit gracefully when exception occurs', () async {
    // make sure there is an exception
    when(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).thenThrow(Exception("--This error message should show in logs--"));

    // trigger event
    bloc.add(ViewDrawingEvent('project123','user123','Title','Subtitle','thumbnail',
    ));

    // wait for async code to complete
    await Future.delayed(Duration.zero);

    // verify check is called
    verify(mockRecentlyViewedService.checkIfAlreadyViewed(
      any, any, any, any,
    )).called(1);

    // verify code does not proceed, and so view does not get called.
    // if we had a log service, we could mock that and verify a log/reporting function was called
    verifyNever(mockRecentlyViewedService.viewDrawing(any));
  });
}
