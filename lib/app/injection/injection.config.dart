// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file_picker/file_picker.dart' as _i5;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:github/github.dart' as _i7;
import 'package:go_router/go_router.dart' as _i18;
import 'package:injectable/injectable.dart' as _i2;
import 'package:langchain_openai/langchain_openai.dart' as _i6;
import 'package:syntax_highlight/syntax_highlight.dart' as _i8;

import '../../data/dart.dart' as _i14;
import '../../data/settings/settings_repository.dart' as _i12;
import '../../domain/domain.dart' as _i22;
import '../../domain/use_cases/create_gist.dart' as _i17;
import '../../domain/use_cases/delete_gist.dart' as _i16;
import '../../domain/use_cases/generate_code_from_image.dart' as _i10;
import '../../domain/use_cases/get_github_key.dart' as _i20;
import '../../domain/use_cases/get_openai_key.dart' as _i19;
import '../../domain/use_cases/replace_image_placeholders.dart' as _i9;
import '../../domain/use_cases/update_github_key.dart' as _i13;
import '../../domain/use_cases/update_openai_key.dart' as _i15;
import '../navigation/navigation_routes.dart' as _i3;
import '../navigation/router.dart' as _i11;
import '../pages/gist/bloc/gist_screen_cubit.dart' as _i21;
import '../pages/home/bloc/home_page_cubit.dart' as _i23;
import 'injection.dart' as _i24;

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
    final injectionModule = _$InjectionModule();
    gh.factory<_i3.NavigationRoutes>(() => _i3.NavigationRoutes());
    gh.factory<_i4.FlutterSecureStorage>(
        () => injectionModule.sharedPreference);
    gh.factory<_i5.FilePicker>(() => injectionModule.filePicker);
    gh.singleton<_i6.ChatOpenAI>(() => injectionModule.chatOpenAI);
    gh.singleton<_i6.OpenAIDallETool>(() => injectionModule.dallETool);
    gh.singleton<_i7.GitHub>(() => injectionModule.gitHub);
    gh.singletonAsync<_i8.Highlighter>(() => injectionModule.highlighter);
    gh.factory<_i9.ReplaceImagePlaceholdersUseCase>(
        () => _i9.ReplaceImagePlaceholdersUseCase(gh<_i6.OpenAIDallETool>()));
    gh.factory<_i10.GenerateCodeFromImageUseCase>(
        () => _i10.GenerateCodeFromImageUseCase(gh<_i6.ChatOpenAI>()));
    gh.factory<_i11.RouterFactory>(
        () => _i11.RouterFactory(gh<_i3.NavigationRoutes>()));
    gh.singleton<_i12.SettingsRepository>(
        () => _i12.SettingsRepository(gh<_i4.FlutterSecureStorage>()));
    gh.factory<_i13.UpdateGitHubKeyUseCase>(() => _i13.UpdateGitHubKeyUseCase(
          gh<_i7.GitHub>(),
          gh<_i14.SettingsRepository>(),
        ));
    gh.factory<_i15.UpdateOpenAiKeyUseCase>(() => _i15.UpdateOpenAiKeyUseCase(
          gh<_i6.ChatOpenAI>(),
          gh<_i6.OpenAIDallETool>(),
          gh<_i14.SettingsRepository>(),
        ));
    gh.factory<_i16.DeleteGistUseCase>(
        () => _i16.DeleteGistUseCase(gh<_i7.GitHub>()));
    gh.factory<_i17.CreateGistUseCase>(
        () => _i17.CreateGistUseCase(gh<_i7.GitHub>()));
    gh.singleton<_i18.GoRouter>(
        () => injectionModule.goRouter(gh<_i11.RouterFactory>()));
    gh.factory<_i19.GetOpenAiKeyUseCase>(
        () => _i19.GetOpenAiKeyUseCase(gh<_i14.SettingsRepository>()));
    gh.factory<_i20.GetGitHubKeyUseCase>(
        () => _i20.GetGitHubKeyUseCase(gh<_i14.SettingsRepository>()));
    gh.factoryParam<_i21.GistScreenCubit, String, dynamic>((
      gistId,
      _,
    ) =>
        _i21.GistScreenCubit(
          gistId,
          gh<_i22.DeleteGistUseCase>(),
          gh<_i18.GoRouter>(),
        ));
    gh.factory<_i23.HomePageCubit>(() => _i23.HomePageCubit(
          gh<_i5.FilePicker>(),
          gh<_i22.GetOpenAiKeyUseCase>(),
          gh<_i22.GetGitHubKeyUseCase>(),
          gh<_i22.UpdateOpenAiKeyUseCase>(),
          gh<_i22.UpdateGitHubKeyUseCase>(),
          gh<_i22.GenerateCodeFromImageUseCase>(),
          gh<_i22.ReplaceImagePlaceholdersUseCase>(),
          gh<_i22.CreateGistUseCase>(),
          gh<_i18.GoRouter>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i24.InjectionModule {}
