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
import 'package:github/github.dart' as _i8;
import 'package:go_router/go_router.dart' as _i19;
import 'package:injectable/injectable.dart' as _i2;
import 'package:langchain_google/langchain_google.dart' as _i7;
import 'package:langchain_openai/langchain_openai.dart' as _i6;
import 'package:syntax_highlight/syntax_highlight.dart' as _i9;

import '../../data/dart.dart' as _i15;
import '../../data/settings/settings_repository.dart' as _i13;
import '../../domain/domain.dart' as _i25;
import '../../domain/use_cases/create_gist.dart' as _i18;
import '../../domain/use_cases/delete_gist.dart' as _i17;
import '../../domain/use_cases/generate_code_from_image.dart' as _i12;
import '../../domain/use_cases/get_gemini_key.dart' as _i23;
import '../../domain/use_cases/get_github_key.dart' as _i22;
import '../../domain/use_cases/get_openai_key.dart' as _i21;
import '../../domain/use_cases/replace_image_placeholders.dart' as _i10;
import '../../domain/use_cases/update_gemini_key.dart' as _i20;
import '../../domain/use_cases/update_github_key.dart' as _i14;
import '../../domain/use_cases/update_openai_key.dart' as _i16;
import '../navigation/navigation_routes.dart' as _i3;
import '../navigation/router.dart' as _i11;
import '../pages/gist/bloc/gist_screen_cubit.dart' as _i24;
import '../pages/home/bloc/home_page_cubit.dart' as _i26;
import 'injection.dart' as _i27;

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
    gh.singleton<_i7.ChatGoogleGenerativeAI>(
        () => injectionModule.chatGoogleGenerativeAI);
    gh.singleton<_i6.OpenAIDallETool>(() => injectionModule.dallETool);
    gh.singleton<_i8.GitHub>(() => injectionModule.gitHub);
    gh.singletonAsync<_i9.Highlighter>(() => injectionModule.highlighter);
    gh.factory<_i10.ReplaceImagePlaceholdersUseCase>(
        () => _i10.ReplaceImagePlaceholdersUseCase(gh<_i6.OpenAIDallETool>()));
    gh.factory<_i11.RouterFactory>(
        () => _i11.RouterFactory(gh<_i3.NavigationRoutes>()));
    gh.factory<_i12.GenerateCodeFromImageUseCase>(
        () => _i12.GenerateCodeFromImageUseCase(
              gh<_i6.ChatOpenAI>(),
              gh<_i7.ChatGoogleGenerativeAI>(),
            ));
    gh.singleton<_i13.SettingsRepository>(
        () => _i13.SettingsRepository(gh<_i4.FlutterSecureStorage>()));
    gh.factory<_i14.UpdateGitHubKeyUseCase>(() => _i14.UpdateGitHubKeyUseCase(
          gh<_i8.GitHub>(),
          gh<_i15.SettingsRepository>(),
        ));
    gh.factory<_i16.UpdateOpenAiKeyUseCase>(() => _i16.UpdateOpenAiKeyUseCase(
          gh<_i6.ChatOpenAI>(),
          gh<_i6.OpenAIDallETool>(),
          gh<_i15.SettingsRepository>(),
        ));
    gh.factory<_i17.DeleteGistUseCase>(
        () => _i17.DeleteGistUseCase(gh<_i8.GitHub>()));
    gh.factory<_i18.CreateGistUseCase>(
        () => _i18.CreateGistUseCase(gh<_i8.GitHub>()));
    gh.singleton<_i19.GoRouter>(
        () => injectionModule.goRouter(gh<_i11.RouterFactory>()));
    gh.factory<_i20.UpdateGeminiKeyUseCase>(() => _i20.UpdateGeminiKeyUseCase(
          gh<_i7.ChatGoogleGenerativeAI>(),
          gh<_i15.SettingsRepository>(),
        ));
    gh.factory<_i21.GetOpenAiKeyUseCase>(
        () => _i21.GetOpenAiKeyUseCase(gh<_i15.SettingsRepository>()));
    gh.factory<_i22.GetGitHubKeyUseCase>(
        () => _i22.GetGitHubKeyUseCase(gh<_i15.SettingsRepository>()));
    gh.factory<_i23.GetGeminiKeyUseCase>(
        () => _i23.GetGeminiKeyUseCase(gh<_i15.SettingsRepository>()));
    gh.factoryParam<_i24.GistScreenCubit, String, dynamic>((
      gistId,
      _,
    ) =>
        _i24.GistScreenCubit(
          gistId,
          gh<_i25.DeleteGistUseCase>(),
          gh<_i19.GoRouter>(),
        ));
    gh.factory<_i26.HomePageCubit>(() => _i26.HomePageCubit(
          gh<_i5.FilePicker>(),
          gh<_i25.GetOpenAiKeyUseCase>(),
          gh<_i23.GetGeminiKeyUseCase>(),
          gh<_i25.GetGitHubKeyUseCase>(),
          gh<_i25.UpdateOpenAiKeyUseCase>(),
          gh<_i20.UpdateGeminiKeyUseCase>(),
          gh<_i25.UpdateGitHubKeyUseCase>(),
          gh<_i25.GenerateCodeFromImageUseCase>(),
          gh<_i25.ReplaceImagePlaceholdersUseCase>(),
          gh<_i25.CreateGistUseCase>(),
          gh<_i19.GoRouter>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i27.InjectionModule {}
