part of 'home_screen_cubit.dart';

@immutable
class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.status = HomeScreenStatus.loading,
    this.imageBytes,
    this.additionalInstructions,
    this.generateImages = false,
    this.storeApiKeys = false,
    this.openAiKey,
    this.githubKey,
    this.generatedCode,
    this.generateCodeError,
  });

  final HomeScreenStatus status;
  final Uint8List? imageBytes;
  final String? additionalInstructions;
  final bool generateImages;
  final bool storeApiKeys;
  final String? openAiKey;
  final String? githubKey;
  final String? generatedCode;
  final Object? generateCodeError;

  HomeScreenState copyWith({
    final HomeScreenStatus? status,
    final Uint8List? imageBytes,
    final String? additionalInstructions,
    final bool? generateImages,
    final bool? storeApiKeys,
    final String? openAiKey,
    final String? githubKey,
    final String? generatedCode,
    final Object? generateCodeError,
  }) {
    return HomeScreenState(
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      additionalInstructions: additionalInstructions ?? this.additionalInstructions,
      generateImages: generateImages ?? this.generateImages,
      storeApiKeys: storeApiKeys ?? this.storeApiKeys,
      openAiKey: openAiKey ?? this.openAiKey,
      githubKey: githubKey ?? this.githubKey,
      generatedCode: generatedCode ?? this.generatedCode,
      generateCodeError: generateCodeError,
    );
  }

  HomeScreenState reset() {
    return HomeScreenState(
      status: HomeScreenStatus.s1SelectImage,
      openAiKey: openAiKey,
      githubKey: githubKey,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imageBytes,
        additionalInstructions,
        generateImages,
        storeApiKeys,
        openAiKey,
        githubKey,
        generatedCode,
        generateCodeError,
      ];
}

enum HomeScreenStatus {
  loading,
  s1SelectImage,
  s2AdditionalInstructions,
  s3ApiKeys,
  s4Generating,
}
