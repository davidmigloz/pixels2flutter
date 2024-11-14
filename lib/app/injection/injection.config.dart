// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file_picker/file_picker.dart' as _i388;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:github/github.dart' as _i535;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:langchain_google/langchain_google.dart' as _i284;
import 'package:langchain_openai/langchain_openai.dart' as _i482;
import 'package:syntax_highlight/syntax_highlight.dart' as _i258;

import '../../data/dart.dart' as _i488;
import '../../data/settings/settings_repository.dart' as _i121;
import '../../domain/domain.dart' as _i614;
import '../../domain/use_cases/create_gist.dart' as _i904;
import '../../domain/use_cases/delete_gist.dart' as _i1043;
import '../../domain/use_cases/generate_code_from_image.dart' as _i84;
import '../../domain/use_cases/get_github_key.dart' as _i610;
import '../../domain/use_cases/get_googleai_key.dart' as _i649;
import '../../domain/use_cases/get_openai_key.dart' as _i857;
import '../../domain/use_cases/replace_image_placeholders.dart' as _i7;
import '../../domain/use_cases/update_github_key.dart' as _i309;
import '../../domain/use_cases/update_google_ai_key.dart' as _i378;
import '../../domain/use_cases/update_openai_key.dart' as _i126;
import '../navigation/navigation_routes.dart' as _i836;
import '../navigation/router.dart' as _i502;
import '../pages/gist/bloc/gist_screen_cubit.dart' as _i824;
import '../pages/home/bloc/home_page_cubit.dart' as _i996;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.factory<_i836.NavigationRoutes>(() => _i836.NavigationRoutes());
    gh.factory<_i558.FlutterSecureStorage>(
        () => injectionModule.sharedPreference);
    gh.factory<_i388.FilePicker>(() => injectionModule.filePicker);
    gh.singleton<_i482.ChatOpenAI>(() => injectionModule.chatOpenAI);
    gh.singleton<_i284.ChatGoogleGenerativeAI>(
        () => injectionModule.chatGoogleGenerativeAI);
    gh.singleton<_i482.OpenAIDallETool>(() => injectionModule.dallETool);
    gh.singleton<_i535.GitHub>(() => injectionModule.gitHub);
    gh.singletonAsync<_i258.Highlighter>(() => injectionModule.highlighter);
    gh.factory<_i7.ReplaceImagePlaceholdersUseCase>(
        () => _i7.ReplaceImagePlaceholdersUseCase(gh<_i482.OpenAIDallETool>()));
    gh.factory<_i502.RouterFactory>(
        () => _i502.RouterFactory(gh<_i836.NavigationRoutes>()));
    gh.factory<_i84.GenerateCodeFromImageUseCase>(
        () => _i84.GenerateCodeFromImageUseCase(
              gh<_i482.ChatOpenAI>(),
              gh<_i284.ChatGoogleGenerativeAI>(),
            ));
    gh.singleton<_i121.SettingsRepository>(
        () => _i121.SettingsRepository(gh<_i558.FlutterSecureStorage>()));
    gh.factory<_i309.UpdateGitHubKeyUseCase>(() => _i309.UpdateGitHubKeyUseCase(
          gh<_i535.GitHub>(),
          gh<_i488.SettingsRepository>(),
        ));
    gh.factory<_i126.UpdateOpenAiKeyUseCase>(() => _i126.UpdateOpenAiKeyUseCase(
          gh<_i482.ChatOpenAI>(),
          gh<_i482.OpenAIDallETool>(),
          gh<_i488.SettingsRepository>(),
        ));
    gh.factory<_i1043.DeleteGistUseCase>(
        () => _i1043.DeleteGistUseCase(gh<_i535.GitHub>()));
    gh.factory<_i904.CreateGistUseCase>(
        () => _i904.CreateGistUseCase(gh<_i535.GitHub>()));
    gh.singleton<_i583.GoRouter>(
        () => injectionModule.goRouter(gh<_i502.RouterFactory>()));
    gh.factory<_i378.UpdateGoogleAiKeyUseCase>(
        () => _i378.UpdateGoogleAiKeyUseCase(
              gh<_i284.ChatGoogleGenerativeAI>(),
              gh<_i488.SettingsRepository>(),
            ));
    gh.factory<_i857.GetOpenAiKeyUseCase>(
        () => _i857.GetOpenAiKeyUseCase(gh<_i488.SettingsRepository>()));
    gh.factory<_i610.GetGitHubKeyUseCase>(
        () => _i610.GetGitHubKeyUseCase(gh<_i488.SettingsRepository>()));
    gh.factory<_i649.GetGoogleAiKeyUseCase>(
        () => _i649.GetGoogleAiKeyUseCase(gh<_i488.SettingsRepository>()));
    gh.factoryParam<_i824.GistScreenCubit, String, dynamic>((
      gistId,
      _,
    ) =>
        _i824.GistScreenCubit(
          gistId,
          gh<_i614.DeleteGistUseCase>(),
          gh<_i583.GoRouter>(),
        ));
    gh.factory<_i996.HomePageCubit>(() => _i996.HomePageCubit(
          gh<_i388.FilePicker>(),
          gh<_i614.GetOpenAiKeyUseCase>(),
          gh<_i614.GetGoogleAiKeyUseCase>(),
          gh<_i614.GetGitHubKeyUseCase>(),
          gh<_i614.UpdateOpenAiKeyUseCase>(),
          gh<_i614.UpdateGoogleAiKeyUseCase>(),
          gh<_i614.UpdateGitHubKeyUseCase>(),
          gh<_i614.GenerateCodeFromImageUseCase>(),
          gh<_i614.ReplaceImagePlaceholdersUseCase>(),
          gh<_i614.CreateGistUseCase>(),
          gh<_i583.GoRouter>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i464.InjectionModule {}
