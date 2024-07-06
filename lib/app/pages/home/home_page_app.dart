import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import '../../../core/constants.dart';
import '../../assets/assets.gen.dart';
import '../../injection/injection.dart';
import 'bloc/home_page_cubit.dart';

class HomePageAppSection extends StatelessWidget {
  const HomePageAppSection({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      buildWhen: (final previous, final current) =>
          previous.status != current.status,
      builder: (final context, final state) {
        switch (state.status) {
          case HomePageStatus.loading:
            return const _S0Loading();
          case HomePageStatus.s1SelectImage:
            return const _S1SelectImage();
          case HomePageStatus.s2AdditionalInstructions:
            return const _S2AdditionalInstructions();
          case HomePageStatus.s3ApiKeys:
            return const _S3ApiKeys();
          case HomePageStatus.s4Generating:
            return const _S4Generating();
        }
      },
    );
  }
}

class _AppCardBody extends StatelessWidget {
  const _AppCardBody({
    required this.title,
    this.hasBackButton = false,
    this.inProgress = false,
    required this.child,
  });

  final String title;
  final bool hasBackButton;
  final bool inProgress;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomePageCubit>();

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            if (hasBackButton) ...[
              const SizedBox(width: 16),
              IconButton(
                onPressed: cubit.onBackButtonPressed,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            if (hasBackButton) const SizedBox(width: 72),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 16,
          ),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );

    if (inProgress) {
      cardContent = cardContent
          .animate(onPlay: (final c) => c.loop())
          .shimmer(
            delay: 500.ms,
            curve: Curves.easeIn,
            duration: 1500.ms,
            color: theme.colorScheme.primary,
          )
          .then(delay: 500.ms)
          .shimmer(
            delay: 500.ms,
            duration: 1500.ms,
            curve: Curves.easeOut,
            color: theme.colorScheme.secondary,
          )
          .then(delay: 500.ms);
    }

    Widget container = Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 768,
        minHeight: 448,
      ),
      child: Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: cardContent.animate().fade(),
      ),
    );

    if (!hasBackButton) {
      container = container
          .animate(delay: 500.ms) //
          .fadeIn(
            duration: 500.ms,
            curve: Curves.easeIn,
          );
    }

    return SliverToBoxAdapter(
      child: Center(child: container),
    );
  }
}

class _S0Loading extends StatelessWidget {
  const _S0Loading();

  @override
  Widget build(final BuildContext context) {
    return const _AppCardBody(
      title: 'Loading...',
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _S1SelectImage extends StatelessWidget {
  const _S1SelectImage();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomePageCubit>();
    return _AppCardBody(
      title: 'Convert a screenshot to Flutter code!',
      child: DropRegion(
        formats: const [Formats.png, Formats.jpeg],
        onDropOver: (final event) => DropOperation.copy,
        onPerformDrop: cubit.onFileDropped,
        child: InkWell(
          onTap: cubit.onSelectFilePressed,
          borderRadius: BorderRadius.circular(16),
          hoverColor: theme.colorScheme.primaryContainer,
          splashColor: Colors.transparent,
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.grey.shade300,
            strokeWidth: 2,
            dashPattern: const [6, 3],
            radius: const Radius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 72, width: double.infinity),
                Assets.selectImage
                    .svg(height: 100)
                    .animate()
                    .fadeIn(delay: 50.ms)
                    .shimmer(delay: 1200.ms, duration: 1800.ms)
                    .shake(hz: 4, curve: Curves.easeInOutCubic)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 600.ms,
                    )
                    .then(delay: 600.ms)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1 / 1.1, 1 / 1.1),
                    ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: cubit.onSelectFilePressed,
                  child: const Text('Select image'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Or drop it here...',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _S2AdditionalInstructions extends StatefulWidget {
  const _S2AdditionalInstructions();

  @override
  State<_S2AdditionalInstructions> createState() =>
      _S2AdditionalInstructionsState();
}

class _S2AdditionalInstructionsState extends State<_S2AdditionalInstructions> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<HomePageCubit>();
    setState(() {
      _controller.text = cubit.state.additionalInstructions ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final imageBytes = cubit.state.screenshot!.data;
    return _AppCardBody(
      title: 'Additional instructions',
      hasBackButton: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(imageBytes, height: 236, width: 212),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'If you want to add some extra instructions, you can do it here.',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Additional instructions... (optional)',
                      ),
                      onChanged: cubit.onAdditionalInstructionsChanged,
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      maxLines: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: cubit.onAdditionalInstructionsSubmitted,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class _S3ApiKeys extends StatefulWidget {
  const _S3ApiKeys();

  @override
  State<_S3ApiKeys> createState() => _S3ApiKeysState();
}

class _S3ApiKeysState extends State<_S3ApiKeys> {
  late TextEditingController _openAIController;
  late TextEditingController _githubController;

  @override
  void initState() {
    super.initState();
    _openAIController = TextEditingController();
    _githubController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<HomePageCubit>();
    setState(() {
      _openAIController.text = cubit.state.openAiKey ?? '';
      _githubController.text = cubit.state.githubKey ?? '';
    });
  }

  @override
  void dispose() {
    _openAIController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomePageCubit>();
    return _AppCardBody(
      title: 'API keys',
      hasBackButton: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HomePageCubit, HomePageState>(
            builder: (final context, final state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SegmentedButton<GenerateCodeProvider>(
                    segments: const <ButtonSegment<GenerateCodeProvider>>[
                      ButtonSegment<GenerateCodeProvider>(
                        value: GenerateCodeProvider.openAI,
                        label: Text('OpenAI'),
                      ),
                      ButtonSegment<GenerateCodeProvider>(
                        value: GenerateCodeProvider.googleAI,
                        label: Text('Gemini'),
                      ),
                    ],
                    selected: {state.generateCodeProvider},
                    onSelectionChanged: (final value) {
                      return cubit.onGenerateCodeProviderChanged(value.first);
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<HomePageCubit, HomePageState>(
            builder: (final context, final state) {
              return Text(
                'We need your ${state.generateCodeProvider.name.toUpperCase()} API key to generate the code and your GitHub personal token to store it in a Gist. '
                'Check the FAQs below to learn how to get them.',
              );
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<HomePageCubit, HomePageState>(
            buildWhen: (final previous, final current) =>
                previous.error != current.error ||
                previous.generateCodeProvider != current.generateCodeProvider,
            builder: (final context, final state) {
              return TextField(
                controller: _openAIController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(
                    '${state.generateCodeProvider.name.toUpperCase()} API key',
                  ),
                  helperText:
                      'Your ${state.generateCodeProvider.name.toUpperCase()} account should be at least "Usage tier 1" to use the GPT-4V(ision) model.',
                  errorText: switch (state.error) {
                    HomePageError.invalidOpenAiApiKey =>
                      'Invalid OpenAI API key. '
                          'Please generate a valid key at platform.openai.com/api-keys.',
                    HomePageError.noAccessToGpt4V =>
                      'Your OpenAI account does not have access to the GPT-4V(ision) model. '
                          'Please upgrade your account to "Usage tier 1" at platform.openai.com/account/billing '
                          '(check the FAQs below for more info).',
                    _ => null,
                  },
                ),
                onChanged:
                    (state.generateCodeProvider == GenerateCodeProvider.openAI)
                        ? cubit.onOpenAiKeyChanged
                        : cubit.onGeminiKeyChanged,
                keyboardType: TextInputType.text,
                obscureText: true,
              );
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _githubController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('GitHub personal token'),
              helperText:
                  'Only Gists read/write permission is required (used to load the code into DartPad).',
            ),
            onChanged: cubit.onGithubKeyChanged,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          const SizedBox(height: 8),
          BlocBuilder<HomePageCubit, HomePageState>(
            buildWhen: (final previous, final current) =>
                previous.storeApiKeys != current.storeApiKeys,
            builder: (final context, final state) {
              return CheckboxListTile(
                title: Text(
                  'Remember my keys for next time (securely stored in your browser)',
                  style: theme.textTheme.bodyMedium,
                ),
                value: state.storeApiKeys,
                onChanged: (final value) {
                  return cubit.onStoreApiKeysChanged(
                    storeApiKeys: value ?? false,
                  );
                },
              );
            },
          ),
          const GenerateImagesCheckbox(),
          const SizedBox(height: 16),
          Center(
            child: BlocBuilder<HomePageCubit, HomePageState>(
              builder: (final context, final state) {
                final canSubmit = (state.openAiKey?.isNotEmpty ?? false) ||
                    (state.geminiKey?.isNotEmpty ?? false) &&
                        (state.githubKey?.isNotEmpty ?? false);
                return FilledButton(
                  onPressed: canSubmit ? cubit.onApiKeysSubmitted : null,
                  child: const Text('Generate code'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GenerateImagesCheckbox extends StatelessWidget {
  const GenerateImagesCheckbox({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final theme = Theme.of(context);
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (final context, final state) {
        return (state.generateCodeProvider == GenerateCodeProvider.openAI)
            ? CheckboxListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Generate images using OpenAI DALL·E',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    const Tooltip(
                      message:
                          'Enable this option if you want to replicate the images '
                          'in the screenshot using OpenAI DALL·E image generator.\n'
                          'Mind that this will increase the generation time and cost.',
                      child: Icon(Icons.info_outline, size: 16),
                    ),
                  ],
                ),
                value: state.generateImages,
                onChanged: (final value) {
                  return cubit.onGenerateImagesChanged(
                    generateImages: value ?? false,
                  );
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class _S4Generating extends StatelessWidget {
  const _S4Generating();

  @override
  Widget build(final BuildContext context) {
    final highlighter = getIt<Highlighter>();
    return _AppCardBody(
      title: 'Generating...',
      hasBackButton: true,
      inProgress: true,
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: SingleChildScrollView(
          reverse: true,
          child: BlocBuilder<HomePageCubit, HomePageState>(
            buildWhen: (final previous, final current) =>
                previous.generatedCode != current.generatedCode,
            builder: (final context, final state) {
              return Text.rich(
                highlighter.highlight(state.generatedCode ?? ''),
                textAlign: TextAlign.start,
              );
            },
          ),
        ),
      ),
    );
  }
}
