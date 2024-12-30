part of 'recent_views_bloc.dart';

@immutable
sealed class RecentViewsState {}

final class RecentViewsInitial extends RecentViewsState {}

final class ViewingState extends RecentViewsInitial {}

final class ViewFailedState extends RecentViewsInitial {
  final Exception exception;
  ViewFailedState(this.exception);
}
final class ViewedState extends RecentViewsInitial {
  final RecentlyViewedDrawingTile drawing;
  ViewedState(this.drawing);
}