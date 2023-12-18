part of 'home_page_cubit.dart';

@immutable
class HomePageState extends Equatable {
  const HomePageState({
    this.status = HomePageStatus.loading,
    this.screenshot,
    this.additionalInstructions,
    this.generateImages = false,
    this.storeApiKeys = false,
    this.openAiKey,
    this.githubKey,
    this.generatedCode,
    this.error,
    this.selectedExample = 0,
  });

  final HomePageStatus status;
  final Screenshot? screenshot;
  final String? additionalInstructions;
  final bool generateImages;
  final bool storeApiKeys;
  final String? openAiKey;
  final String? githubKey;
  final String? generatedCode;
  final HomePageError? error;
  final int selectedExample;

  HomePageState copyWith({
    final HomePageStatus? status,
    final Screenshot? screenshot,
    final String? additionalInstructions,
    final bool? generateImages,
    final bool? storeApiKeys,
    final String? openAiKey,
    final String? githubKey,
    final String? generatedCode,
    final HomePageError? error,
    final int? selectedExample,
  }) {
    return HomePageState(
      status: status ?? this.status,
      screenshot: screenshot ?? this.screenshot,
      additionalInstructions: additionalInstructions ?? this.additionalInstructions,
      generateImages: generateImages ?? this.generateImages,
      storeApiKeys: storeApiKeys ?? this.storeApiKeys,
      openAiKey: openAiKey ?? this.openAiKey,
      githubKey: githubKey ?? this.githubKey,
      generatedCode: generatedCode ?? this.generatedCode,
      error: error,
      selectedExample: selectedExample ?? this.selectedExample,
    );
  }

  HomePageState reset() {
    return HomePageState(
      status: HomePageStatus.s1SelectImage,
      storeApiKeys: storeApiKeys,
      openAiKey: openAiKey,
      githubKey: githubKey,
      selectedExample: selectedExample,
    );
  }

  @override
  List<Object?> get props => [
        status,
        screenshot,
        additionalInstructions,
        generateImages,
        storeApiKeys,
        openAiKey,
        githubKey,
        generatedCode,
        error,
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

enum HomePageError {
  invalidOpenAiApiKey,
  noAccessToGpt4V,
  unknown,
}
