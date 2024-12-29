// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ardennes/features/drawing_detail/drawing_detail_bloc.dart'
    as _i10;
import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart'
    as _i6;
import 'package:ardennes/features/drawings_catalog/recently_viewed_drawing_service.dart'
    as _i8;
import 'package:ardennes/injection.dart' as _i11;
import 'package:ardennes/libraries/account_context/bloc.dart' as _i3;
import 'package:ardennes/libraries/drawing/drawing_catalog_loader.dart' as _i4;
import 'package:ardennes/libraries/drawing/image_provider.dart' as _i9;
import 'package:ardennes/models/projects/project_metadata.dart' as _i5;
import 'package:cloud_firestore/cloud_firestore.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.AccountContextBloc>(() => registerModule.accountContextBloc);
    gh.factoryParam<_i4.DrawingCatalogService, _i5.ProjectMetadata?, dynamic>((
      savedSelectedProject,
      _,
    ) =>
        _i4.DrawingCatalogService(savedSelectedProject: savedSelectedProject));
    gh.factory<_i6.DrawingsCatalogBloc>(
        () => registerModule.drawingsCatalogBloc);
    gh.lazySingleton<_i7.FirebaseFirestore>(() => registerModule.firestore);
    gh.factory<_i8.RecentlyViewedService>(
        () => _i8.RecentlyViewedService(gh<_i7.FirebaseFirestore>()));
    gh.factory<_i9.UIImageProvider>(() => _i9.UIImageProvider());
    gh.factory<_i10.DrawingDetailBloc>(() =>
        _i10.DrawingDetailBloc(uiImageProvider: gh<_i9.UIImageProvider>()));
    return this;
  }
}

class _$RegisterModule extends _i11.RegisterModule {}
