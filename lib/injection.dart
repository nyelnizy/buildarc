import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart';
import 'package:ardennes/features/drawings_catalog/recently_viewed_drawing_service.dart';
import 'package:ardennes/features/home_screen/bloc.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/drawing/drawing_catalog_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}

@module
abstract class RegisterModule {
  @factoryMethod
  DrawingsCatalogBloc get drawingsCatalogBloc =>
      DrawingsCatalogBloc(getIt<DrawingCatalogService>(),getIt<RecentlyViewedService>());

  @factoryMethod
  AccountContextBloc get accountContextBloc => AccountContextBloc();

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  HomeScreenBloc get homeScreenBloc => HomeScreenBloc();
}
