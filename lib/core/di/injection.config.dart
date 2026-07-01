// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasources/auth_remote_data_source.dart' as _i716;
import '../../data/datasources/cart_remote_datasource.dart' as _i343;
import '../../data/datasources/order_remote_datasource.dart' as _i1004;
import '../../data/datasources/product_remote_datasource.dart' as _i835;
import '../../data/datasources/wishlist_remote_datasource.dart' as _i112;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/cart_repository_impl.dart' as _i915;
import '../../data/repositories/order_repository_impl.dart' as _i717;
import '../../data/repositories/product_repository_impl.dart' as _i876;
import '../../data/repositories/wishlist_repository_impl.dart' as _i800;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/cart_repository.dart' as _i46;
import '../../domain/repositories/order_repository.dart' as _i507;
import '../../domain/repositories/product_repository.dart' as _i933;
import '../../domain/repositories/wishlist_repository.dart' as _i581;
import '../../presentation/blocs/auth/auth_bloc.dart' as _i141;
import '../../presentation/blocs/cart/cart_bloc.dart' as _i902;
import '../../presentation/blocs/order/order_bloc.dart' as _i25;
import '../../presentation/blocs/product/product_bloc.dart' as _i747;
import '../../presentation/blocs/wishlist/wishlist_bloc.dart' as _i886;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => registerModule.firebaseStorage,
    );
    gh.factory<_i343.CartRemoteDataSource>(
      () => _i343.CartRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1004.OrderRemoteDataSource>(
      () => _i1004.OrderRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i835.ProductRemoteDataSource>(
      () => _i835.ProductRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i112.WishlistRemoteDataSource>(
      () => _i112.WishlistRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i507.OrderRepository>(
      () => _i717.OrderRepositoryImpl(gh<_i1004.OrderRemoteDataSource>()),
    );
    gh.factory<_i933.ProductRepository>(
      () => _i876.ProductRepositoryImpl(gh<_i835.ProductRemoteDataSource>()),
    );
    gh.factory<_i46.CartRepository>(
      () => _i915.CartRepositoryImpl(gh<_i343.CartRemoteDataSource>()),
    );
    gh.lazySingleton<_i716.AuthRemoteDataSource>(
      () => _i716.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i25.OrderBloc>(
      () => _i25.OrderBloc(
        gh<_i507.OrderRepository>(),
        gh<_i46.CartRepository>(),
      ),
    );
    gh.factory<_i581.WishlistRepository>(
      () => _i800.WishlistRepositoryImpl(
        gh<_i112.WishlistRemoteDataSource>(),
        gh<_i933.ProductRepository>(),
      ),
    );
    gh.factory<_i886.WishlistBloc>(
      () => _i886.WishlistBloc(gh<_i581.WishlistRepository>()),
    );
    gh.factory<_i902.CartBloc>(() => _i902.CartBloc(gh<_i46.CartRepository>()));
    gh.factory<_i747.ProductBloc>(
      () => _i747.ProductBloc(gh<_i933.ProductRepository>()),
    );
    gh.lazySingleton<_i1073.AuthRepository>(
      () => _i895.AuthRepositoryImpl(gh<_i716.AuthRemoteDataSource>()),
    );
    gh.factory<_i141.AuthBloc>(
      () => _i141.AuthBloc(gh<_i1073.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
