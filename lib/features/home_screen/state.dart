import 'package:ardennes/models/screens/home_screen_data.dart';
import 'package:equatable/equatable.dart';

class HomeScreenState implements Equatable {
  HomeScreenState init() {
    return HomeScreenState();
  }

  HomeScreenState clone() {
    return HomeScreenState();
  }

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class FetchingHomeScreenContentState extends HomeScreenState {
  @override
  FetchingHomeScreenContentState clone() {
    return FetchingHomeScreenContentState();
  }
}

class FetchedHomeScreenContentState extends HomeScreenState {
  final List<RecentlyViewedDrawingTile> recentlyViewedDrawingTiles;

  FetchedHomeScreenContentState({
    required this.recentlyViewedDrawingTiles,
  });

  @override
  FetchedHomeScreenContentState clone() {
    return FetchedHomeScreenContentState(
      recentlyViewedDrawingTiles: recentlyViewedDrawingTiles,
    );
  }
  @override
  List<Object?> get props => [recentlyViewedDrawingTiles];
}

class HomeScreenFetchErrorState extends HomeScreenState {
  final String errorMessage;

  HomeScreenFetchErrorState(this.errorMessage);

  @override
  HomeScreenFetchErrorState clone() {
    return HomeScreenFetchErrorState(errorMessage);
  }
}
