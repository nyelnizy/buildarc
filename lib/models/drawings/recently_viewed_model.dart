class RecentlyViewed {
  String? id;
  String? projectId;
  String? userId;
  Drawing? drawing;

  RecentlyViewed({this.id, this.projectId, this.userId, this.drawing});

  RecentlyViewed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    userId = json['user_id'];
    drawing =
        json['drawing'] != null ? Drawing?.fromJson(json['drawing']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['project_id'] = projectId;
    data['user_id'] = userId;
    if (drawing != null) {
      data['drawing'] = drawing?.toJson();
    }
    return data;
  }
}

class Drawing {
  String? title;
  String? subtitle;
  String? drawingThumbnailUrl;

  Drawing({this.title, this.subtitle, this.drawingThumbnailUrl});

  Drawing.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    drawingThumbnailUrl = json['drawingThumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['drawingThumbnailUrl'] = drawingThumbnailUrl;
    return data;
  }
}
