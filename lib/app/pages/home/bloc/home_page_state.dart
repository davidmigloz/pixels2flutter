part of 'home_page_cubit.dart';

@immutable
class HomePageState extends Equatable {
  const HomePageState({
    this.status = HomePageStatus.loading,
    this.imageBytes,
    this.additionalInstructions,
    this.generateImages = false,
    this.storeApiKeys = false,
    this.openAiKey,
    this.githubKey,
    this.generatedCode,
    this.generateCodeError,
    this.selectedExample = 0,
  });

  final HomePageStatus status;
  final Uint8List? imageBytes;
  final String? additionalInstructions;
  final bool generateImages;
  final bool storeApiKeys;
  final String? openAiKey;
  final String? githubKey;
  final String? generatedCode;
  final Object? generateCodeError;
  final int selectedExample;

  HomePageState copyWith({
    final HomePageStatus? status,
    final Uint8List? imageBytes,
    final String? additionalInstructions,
    final bool? generateImages,
    final bool? storeApiKeys,
    final String? openAiKey,
    final String? githubKey,
    final String? generatedCode,
    final Object? generateCodeError,
    final int? selectedExample,
  }) {
    return HomePageState(
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      additionalInstructions: additionalInstructions ?? this.additionalInstructions,
      generateImages: generateImages ?? this.generateImages,
      storeApiKeys: storeApiKeys ?? this.storeApiKeys,
      openAiKey: openAiKey ?? this.openAiKey,
      githubKey: githubKey ?? this.githubKey,
      generatedCode: generatedCode ?? this.generatedCode,
      generateCodeError: generateCodeError,
      selectedExample: selectedExample ?? this.selectedExample,
    );
  }

  HomePageState reset() {
    return HomePageState(
      status: HomePageStatus.s1SelectImage,
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
        selectedExample,
      ];
}

enum HomePageStatus {
  loading,
  s1SelectImage,
  s2AdditionalInstructions,
  s3ApiKeys,
  s4Generating,
}
