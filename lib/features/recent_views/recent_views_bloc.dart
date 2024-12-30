import 'package:ardennes/features/home_screen/bloc.dart';
import 'package:ardennes/features/home_screen/state.dart';
import 'package:ardennes/models/screens/home_screen_data.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../injection.dart';
import '../../models/drawings/recently_viewed_model.dart';
import '../../models/projects/project_metadata.dart';
import '../drawings_catalog/recently_viewed_drawing_service.dart';
import '../home_screen/event.dart';

part 'recent_views_event.dart';
part 'recent_views_state.dart';

class RecentViewsBloc extends Bloc<RecentViewsEvent, RecentViewsState> {
  final RecentlyViewedService recentlyViewedService;
  RecentViewsBloc(this.recentlyViewedService) : super(RecentViewsInitial()) {
    on<ViewDrawing>(_viewDrawing);
  }
  _viewDrawing(
      ViewDrawing event, Emitter<RecentViewsState> emit) async {
    try {

      var hasViewed = await recentlyViewedService.checkIfAlreadyViewed(
          event.userId!, event.selectedProject.id!, event.title!, event.subtitle!);
      // check if user has already viewed this drawing, if not, view it.
      if (!hasViewed) {
        print("viewing drawing----------------");
        // emit(ViewingState());
        var drawing = Drawing(
            title: event.title,
            subtitle: event.subtitle,
            drawingThumbnailUrl: event.thumbnail);
        await recentlyViewedService.viewDrawing(RecentlyViewed(
            userId: event.userId!,
            projectId: event.selectedProject.id,
            drawing: drawing));
        var drawingForHomeScreen = RecentlyViewedDrawingTile(
          title: drawing.title!,
          subtitle: drawing.subtitle!,
          drawingThumbnailUrl: drawing.drawingThumbnailUrl!,
        );
        var bloc = getIt<HomeScreenBloc>();
        print(bloc.state.runtimeType);
        if(bloc.state is FetchedHomeScreenContentState){
          print("always run after view-----------");
           bloc.add(UpdateRecentViews(drawingForHomeScreen));
        }
        // emit(ViewedState(drawingForHomeScreen));
      }

    } on Exception catch (e) {
      emit(ViewFailedState(e));
      // we could log this in an error reporting system like sentry.
      //eg. loggingService.log(e)
    }
  }
}
