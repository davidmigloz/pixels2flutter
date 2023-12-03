// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file_picker/file_picker.dart' as _i4;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:github/github.dart' as _i7;
import 'package:go_router/go_router.dart' as _i20;
import 'package:injectable/injectable.dart' as _i2;
import 'package:langchain_openai/langchain_openai.dart' as _i3;
import 'package:syntax_highlight/syntax_highlight.dart' as _i8;

import '../../data/dart.dart' as _i14;
import '../../data/settings/settings_repository.dart' as _i12;
import '../../domain/domain.dart' as _i22;
import '../../domain/use_cases/create_gist.dart' as _i16;
import '../../domain/use_cases/delete_gist.dart' as _i17;
import '../../domain/use_cases/generate_code_from_image.dart' as _i6;
import '../../domain/use_cases/get_github_key.dart' as _i18;
import '../../domain/use_cases/get_openai_key.dart' as _i19;
import '../../domain/use_cases/replace_image_placeholders.dart' as _i10;
import '../../domain/use_cases/update_github_key.dart' as _i13;
import '../../domain/use_cases/update_openai_key.dart' as _i15;
import '../navigation/navigation_routes.dart' as _i9;
import '../navigation/router.dart' as _i11;
import '../pages/gist/bloc/gist_screen_cubit.dart' as _i23;
import '../pages/home/bloc/home_page_cubit.dart' as _i21;
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
    gh.singleton<_i3.ChatOpenAI>(injectionModule.chatOpenAI);
    gh.factory<_i4.FilePicker>(() => injectionModule.filePicker);
    gh.factory<_i5.FlutterSecureStorage>(() => injectionModule.sharedPreference);
    gh.factory<_i6.GenerateCodeFromImageUseCase>(() => _i6.GenerateCodeFromImageUseCase(gh<_i3.ChatOpenAI>()));
    gh.singleton<_i7.GitHub>(injectionModule.gitHub);
    gh.singletonAsync<_i8.Highlighter>(() => injectionModule.highlighter);
    gh.factory<_i9.NavigationRoutes>(() => _i9.NavigationRoutes());
    gh.singleton<_i3.OpenAIDallETool>(injectionModule.dallETool);
    gh.factory<_i10.ReplaceImagePlaceholdersUseCase>(
        () => _i10.ReplaceImagePlaceholdersUseCase(gh<_i3.OpenAIDallETool>()));
    gh.factory<_i11.RouterFactory>(() => _i11.RouterFactory(gh<_i9.NavigationRoutes>()));
    gh.singleton<_i12.SettingsRepository>(_i12.SettingsRepository(gh<_i5.FlutterSecureStorage>()));
    gh.factory<_i13.UpdateGitHubKeyUseCase>(() => _i13.UpdateGitHubKeyUseCase(
          gh<_i7.GitHub>(),
          gh<_i14.SettingsRepository>(),
        ));
    gh.factory<_i15.UpdateOpenAiKeyUseCase>(() => _i15.UpdateOpenAiKeyUseCase(
          gh<_i3.ChatOpenAI>(),
          gh<_i3.OpenAIDallETool>(),
          gh<_i14.SettingsRepository>(),
        ));
    gh.factory<_i16.CreateGistUseCase>(() => _i16.CreateGistUseCase(gh<_i7.GitHub>()));
    gh.factory<_i17.DeleteGistUseCase>(() => _i17.DeleteGistUseCase(gh<_i7.GitHub>()));
    gh.factory<_i18.GetGitHubKeyUseCase>(() => _i18.GetGitHubKeyUseCase(gh<_i14.SettingsRepository>()));
    gh.factory<_i19.GetOpenAiKeyUseCase>(() => _i19.GetOpenAiKeyUseCase(gh<_i14.SettingsRepository>()));
    gh.singleton<_i20.GoRouter>(injectionModule.goRouter(gh<_i11.RouterFactory>()));
    gh.factory<_i21.HomePageCubit>(() => _i21.HomePageCubit(
          gh<_i4.FilePicker>(),
          gh<_i22.GetOpenAiKeyUseCase>(),
          gh<_i22.GetGitHubKeyUseCase>(),
          gh<_i22.UpdateOpenAiKeyUseCase>(),
          gh<_i22.UpdateGitHubKeyUseCase>(),
          gh<_i22.GenerateCodeFromImageUseCase>(),
          gh<_i22.ReplaceImagePlaceholdersUseCase>(),
          gh<_i22.CreateGistUseCase>(),
          gh<_i20.GoRouter>(),
        ));
    gh.factoryParam<_i23.GistScreenCubit, String, dynamic>((
      gistId,
      _,
    ) =>
        _i23.GistScreenCubit(
          gistId,
          gh<_i22.DeleteGistUseCase>(),
          gh<_i20.GoRouter>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i24.InjectionModule {}
