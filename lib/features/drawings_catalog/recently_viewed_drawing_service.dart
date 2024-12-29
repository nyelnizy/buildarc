import 'package:ardennes/models/drawings/recently_viewed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class RecentlyViewedService {
  final FirebaseFirestore firestore;
  RecentlyViewedService(this.firestore);

  checkIfAlreadyViewed(
      String userId, String projectId, String title, String subtitle) async {
    var views = firestore.collection("user_drawing_views");
    var allUserViews = await views
        .where("project_id", isEqualTo: projectId)
        .where("user_id", isEqualTo: userId)
        .get();
    var record = allUserViews.docs.firstOrNull;

    // user has not viewed any drawings for this project yet
    if( record == null){
      return false;
    }
    //there will be only one recently viewed record for each user
    var data = record.data();
    for (var d in data["drawings"]) {
      // because there is no specific ID for drawing view,
      // use title and subtitle to check if it is the same drawing,
      // we can make it better in the future
      if (d["title"] == title && d["subtitle"] == subtitle) {
        return true;
      }
    }

    return false;
  }

  Future<void> viewDrawing(RecentlyViewed view) async {
    var views = firestore.collection("user_drawing_views");
    var allUserViews = await views
        .where("project_id", isEqualTo: view.projectId)
        .where("user_id", isEqualTo: view.userId)
        .get();

    var record = allUserViews.docs.firstOrNull;
    List drawings = [];
    String? id;
    if(record != null){
      id = record.id;
      drawings = record.data()['drawings'];
    }
    drawings.add({
      "title": view.drawing!.title,
      "subtitle": view.drawing!.subtitle,
      "drawingThumbnailUrl": view.drawing!.drawingThumbnailUrl,
    });
    // view drawing
    await views.doc(id).set({
      "project_id": view.projectId,
      "user_id": view.userId,
      "drawings": drawings,
    });
  }
}
