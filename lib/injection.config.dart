// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart'
    as _i6;
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart' as _i117;
import 'package:flutter_ddd/infrastructure/auth/firebase_auth_facade.dart'
    as _i514;
import 'package:flutter_ddd/infrastructure/core/firebase_injectable_module.dart'
    as _i670;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth,
    );
    gh.lazySingleton<_i116.GoogleSignIn>(
      () => firebaseInjectableModule.googleSignIn,
    );
    gh.lazySingleton<_i117.IAuthFacade>(
      () => _i514.FirebaseAuthFacade(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factory<_i6.SignInFormBloc>(
      () => _i6.SignInFormBloc(gh<_i117.IAuthFacade>()),
    );
    return this;
  }
}

class _$FirebaseInjectableModule extends _i670.FirebaseInjectableModule {}
