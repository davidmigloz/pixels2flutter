import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/entities/entities.dart';
import '../../../navigation/navigation_urls.dart';

part 'home_page_state.dart';

@injectable
class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(
    this._filePicker,
    this._getOpenAiKeyUseCase,
    this._getGitHubKeyUseCase,
    this._updateOpenAiKeyUseCase,
    this._updateGitHubKeyUseCase,
    this._generateCodeFromImageUseCase,
    this._replaceImagePlaceholdersUseCase,
    this._createGistUseCase,
    this._router,
  ) : super(const HomePageState()) {
    unawaited(_loadKeys());
  }

  final FilePicker _filePicker;
  final GetOpenAiKeyUseCase _getOpenAiKeyUseCase;
  final GetGitHubKeyUseCase _getGitHubKeyUseCase;
  final UpdateOpenAiKeyUseCase _updateOpenAiKeyUseCase;
  final UpdateGitHubKeyUseCase _updateGitHubKeyUseCase;
  final GenerateCodeFromImageUseCase _generateCodeFromImageUseCase;
  final ReplaceImagePlaceholdersUseCase _replaceImagePlaceholdersUseCase;
  final CreateGistUseCase _createGistUseCase;
  final GoRouter _router;

  StreamSubscription<dynamic>? _generateCodeSubscription;

  Future<void> _loadKeys() async {
    if (state.status != HomePageStatus.loading) {
      return;
    }
    final openAiKey = (await _getOpenAiKeyUseCase()).getOrNull();
    final githubKey = (await _getGitHubKeyUseCase()).getOrNull();
    emit(
      state.copyWith(
        status: HomePageStatus.s1SelectImage,
        openAiKey: openAiKey,
        githubKey: githubKey,
        storeApiKeys: openAiKey?.isNotEmpty,
      ),
    );
  }

  void onBackButtonPressed() {
    final currentStatus = state.status;
    if (currentStatus.index <= HomePageStatus.s1SelectImage.index) {
      return;
    }

    final newStatus = HomePageStatus.values[currentStatus.index - 1];
    emit(state.copyWith(status: newStatus));
  }

  Future<void> onSelectFilePressed() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final res = await _filePicker.pickFiles(type: FileType.image);
    if (res == null || res.files.isEmpty) {
      return;
    }

    final file = res.files.first;
    final mimeType = file.extension?.toLowerCase() == 'png' ? 'image/png' : 'image/jpeg';
    final imageBytes = file.bytes!;
    _onScreenshotLoaded(
      Screenshot(
        mimeType: mimeType,
        data: imageBytes,
      ),
    );
  }

  Future<void> onFileDropped(final PerformDropEvent event) async {
    final items = event.session.items;
    if (items.isEmpty) {
      return;
    }

    final reader = items.first.dataReader!;
    final format = reader.canProvide(Formats.png)
        ? Formats.png
        : reader.canProvide(Formats.jpeg)
            ? Formats.jpeg
            : null;

    if (format == null) {
      return;
    }

    reader.getFile(format, (final file) async {
      final imageBytes = await file.readAll();
      _onScreenshotLoaded(
        Screenshot(
          mimeType: format.mimeTypes!.first,
          data: imageBytes,
        ),
      );
    });
  }

  void _onScreenshotLoaded(final Screenshot screenshot) {
    emit(
      state.copyWith(
        status: HomePageStatus.s2AdditionalInstructions,
        screenshot: screenshot,
      ),
    );
  }

  void onAdditionalInstructionsChanged(final String additionalInfo) {
    emit(state.copyWith(additionalInstructions: additionalInfo));
  }

  void onGenerateImagesChanged({required final bool generateImages}) {
    emit(state.copyWith(generateImages: generateImages));
  }

  void onAdditionalInstructionsSubmitted() {
    emit(state.copyWith(status: HomePageStatus.s3ApiKeys));
  }

  void onOpenAiKeyChanged(final String openAiKey) {
    emit(state.copyWith(openAiKey: openAiKey));
  }

  void onGithubKeyChanged(final String githubKey) {
    emit(state.copyWith(githubKey: githubKey));
  }

  void onStoreApiKeysChanged({required final bool storeApiKeys}) {
    emit(state.copyWith(storeApiKeys: storeApiKeys));
  }

  Future<void> onApiKeysSubmitted() async {
    final openAiKey = state.openAiKey;
    final githubKey = state.githubKey;
    final storeApiKeys = state.storeApiKeys;
    if (openAiKey == null || githubKey == null) {
      return;
    }

    await _updateOpenAiKeyUseCase(
      params: UpdateOpenAIKeyUseCaseParams(
        key: openAiKey,
        storeApiKeys: storeApiKeys,
      ),
    );
    await _updateGitHubKeyUseCase(
      params: UpdateGitHubKeyUseCaseParams(
        key: githubKey,
        storeApiKeys: storeApiKeys,
      ),
    );
    emit(state.copyWith(status: HomePageStatus.s4Generating));
    unawaited(_generateCode());
  }

  Future<void> _generateCode() async {
    final stream = _generateCodeFromImageUseCase(
      params: GenerateCodeFromImageUseCaseParams(
        provider: GenerateCodeProvider.googleAI, // TODO get from UI
        screenshot: state.screenshot!,
        additionalInstructions:
            (state.additionalInstructions?.isNotEmpty ?? false) ? state.additionalInstructions : null,
      ),
    );
    await _generateCodeSubscription?.cancel();
    _generateCodeSubscription = stream.listen(
      (final res) {
        res.fold(
          _onGenerateCodeDelta,
          _onGenerateCodeFailure,
        );
      },
      onDone: () => _onGenerateCodeCompleted(state.generatedCode!),
    );
  }

  void _onGenerateCodeDelta(final String delta) {
    emit(
      state.copyWith(
        generatedCode: (state.generatedCode ?? '') + delta,
      ),
    );
  }

  Future<void> _onGenerateCodeFailure(final GenerateCodeFromImageFailure failure) async {
    switch (failure) {
      case GenerateCodeFromImageFailure.invalidApiKey:
        emit(state.copyWith(status: HomePageStatus.s3ApiKeys, error: HomePageError.invalidOpenAiApiKey));
      case GenerateCodeFromImageFailure.noAccessToGpt4V:
        emit(state.copyWith(status: HomePageStatus.s3ApiKeys, error: HomePageError.noAccessToGpt4V));
      case GenerateCodeFromImageFailure.unknown:
        emit(state.reset().copyWith(status: HomePageStatus.s1SelectImage, error: HomePageError.unknown));
    }
  }

  Future<void> _onGenerateCodeCompleted(final String generatedCode) async {
    await _replaceImagePlaceholdersIfNeeded(generatedCode);
  }

  Future<void> _replaceImagePlaceholdersIfNeeded(
    final String generatedCode,
  ) async {
    String code = generatedCode;
    if (state.generateImages) {
      final res = await _replaceImagePlaceholdersUseCase(
        params: ReplaceImagePlaceholdersUseCaseParams(code: generatedCode),
      );
      code = res.getOrDefault(generatedCode);
    }
    await _createGist(code);
  }

  Future<void> _createGist(final String generatedCode) async {
    final res = await _createGistUseCase(
      params: CreateGistUseCaseParams(code: generatedCode),
    );
    await res.fold(
      _onGistCreated,
      _onErrorCreatingGist,
    );
  }

  Future<void> _onGistCreated(final String gistId) async {
    emit(state.reset());
    await _router.push(NavUrl.gist(gistId: gistId));
  }

  Future<void> _onErrorCreatingGist(final Exception e) async {
    emit(state.reset().copyWith(status: HomePageStatus.s1SelectImage, error: HomePageError.unknown));
  }

  void onExampleSelected(final int example) {
    emit(state.copyWith(selectedExample: example));
  }

  @override
  Future<void> close() {
    _generateCodeSubscription?.cancel();
    return super.close();
  }
}
