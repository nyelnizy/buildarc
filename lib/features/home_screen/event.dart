import 'package:ardennes/models/projects/project_metadata.dart';
import 'package:ardennes/models/screens/home_screen_data.dart';

sealed class HomeScreenEvent {}

class InitEvent extends HomeScreenEvent {}
class UpdateRecentViews extends HomeScreenEvent {
   RecentlyViewedDrawingTile recentlyViewedDrawingTile;
   UpdateRecentViews(this.recentlyViewedDrawingTile);
}
class FetchHomeScreenContentEvent extends HomeScreenEvent {
  final ProjectMetadata selectedProject;

  FetchHomeScreenContentEvent(this.selectedProject);
}
