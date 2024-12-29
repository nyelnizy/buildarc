
import 'package:ardennes/features/drawing_detail/drawing_detail_bloc.dart';
import 'package:ardennes/features/drawing_detail/drawing_detail_event.dart';
import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart';
import 'package:ardennes/features/drawings_catalog/drawings_catalog_state.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/account_context/state.dart';
import 'package:ardennes/libraries/core_ui/image_downloading/image_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../drawings_catalog/drawings_catalog_event.dart';

class DrawingsCatalog extends StatelessWidget {
  final ScrollController? scrollController;
  final VoidCallback? onLoadSheet;

  const DrawingsCatalog({Key? key, this.scrollController, this.onLoadSheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingsCatalogBloc, DrawingsCatalogState>(
      builder: (context, state) {
        if (state is FetchedDrawingsCatalogState) {
          final items = state.displayedItems;
          return ListView.builder(
            controller: scrollController ?? ScrollController(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: ImageFromFirebase(imageUrl: item.smallThumbnailUrl),
                // Display the smallThumbnail
                title: Text(item.title),
                // Display the title
                subtitle: Text(item.discipline),
                // Display the discipline
                onTap: () {
                  context.read<DrawingDetailBloc>().add(
                    LoadSheet(
                        number: item.title,
                        collection: item.collection,
                        versionId: item.versionId,
                        projectId: state.drawingsCatalog.projectId),
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  var bloc =  context.read<DrawingsCatalogBloc>();
                  var accBloc =  context.read<AccountContextBloc>();
                  bloc.add(ViewDrawingEvent((accBloc.state as AccountContextLoadedState).selectedProject!, user!.uid, item.title, item.discipline, item.thumbnailUrl));
                  onLoadSheet?.call();
                },
              );
            },
          );
        } else {
          // Handle other states or return an empty Container
          return Container();
        }
      },
    );
  }
}
