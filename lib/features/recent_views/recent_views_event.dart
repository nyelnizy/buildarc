part of 'recent_views_bloc.dart';

@immutable
sealed class RecentViewsEvent {}
class ViewDrawing extends RecentViewsEvent {
  final ProjectMetadata selectedProject;
  final String? userId;
  final String? title;
  final String? subtitle;
  final String? thumbnail;
  ViewDrawing(this.selectedProject,this.userId,this.title,this.subtitle,this.thumbnail);
}