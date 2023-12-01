import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../assets/assets.gen.dart';
import '../../injection/injection.dart';
import 'bloc/home_screen_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final _) => getIt<HomeScreenCubit>(),
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold();

  @override
  Widget build(final BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
      child: const SelectionArea(
        child: Scaffold(
          body: _Body(),
        ),
      ),
      listenWhen: (final previous, final current) => previous.generateCodeError != current.generateCodeError,
      listener: (final context, final state) {
        if (state.generateCodeError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error generating code. Please try again.'),
            ),
          );
        }
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(final BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.9,
          colors: [
            Color(0xFF5877F5),
            Color(0xFF023379),
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _Logo(),
          _AppCard(),
          _HowItWorks(),
          _FAQs(),
          _Footer(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                hoverColor: theme.colorScheme.surfaceTint,
                onPressed: () async {
                  await launchUrl(
                    Uri.parse('https://github.com/davidmigloz/pixels2flutter'),
                  );
                },
                icon: Opacity(
                  opacity: 0.9,
                  child: Assets.github.svg(
                    height: 36,
                  ),
                ),
              ),
            ),
          ),
          Assets.pixels2flutter
              .svg(height: 230)
              .animate(delay: 500.ms) //
              .fadeIn(
                duration: 500.ms,
                curve: Curves.easeIn,
              ),
        ],
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      buildWhen: (final previous, final current) => previous.status != current.status,
      builder: (final context, final state) {
        return _AppCardBody(
          title: _getTitle(state),
          hasBackButton: state.status != HomeScreenStatus.s1SelectImage,
          inProgress: state.status == HomeScreenStatus.s4Generating,
          child: _getChild(state),
        );
      },
    );
  }

  String _getTitle(final HomeScreenState state) {
    switch (state.status) {
      case HomeScreenStatus.loading:
        return 'Loading...';
      case HomeScreenStatus.s1SelectImage:
        return 'Convert a screenshot to Flutter code!';
      case HomeScreenStatus.s2AdditionalInstructions:
        return 'Additional instructions';
      case HomeScreenStatus.s3ApiKeys:
        return 'API keys';
      case HomeScreenStatus.s4Generating:
        return 'Generating...';
    }
  }

  Widget _getChild(final HomeScreenState state) {
    switch (state.status) {
      case HomeScreenStatus.loading:
        return const CircularProgressIndicator();
      case HomeScreenStatus.s1SelectImage:
        return const _S1SelectImage();
      case HomeScreenStatus.s2AdditionalInstructions:
        return const _S2AdditionalInstructions();
      case HomeScreenStatus.s3ApiKeys:
        return const _S3ApiKeys();
      case HomeScreenStatus.s4Generating:
        return const _S4Generating();
    }
  }
}

class _AppCardBody extends StatelessWidget {
  const _AppCardBody({
    required this.title,
    required this.hasBackButton,
    required this.child,
    required this.inProgress,
  });

  final String title;
  final bool hasBackButton;
  final Widget child;
  final bool inProgress;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomeScreenCubit>();

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

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
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
            child: cardContent,
          ),
        )
            .animate(delay: 500.ms) //
            .fadeIn(
              duration: 500.ms,
              curve: Curves.easeIn,
            ),
      ),
    );
  }
}

class _S1SelectImage extends StatelessWidget {
  const _S1SelectImage();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomeScreenCubit>();
    return DropRegion(
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
    ).animate().fade();
  }
}

class _S2AdditionalInstructions extends StatefulWidget {
  const _S2AdditionalInstructions();

  @override
  State<_S2AdditionalInstructions> createState() => _S2AdditionalInstructionsState();
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
    final cubit = context.read<HomeScreenCubit>();
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
    final theme = Theme.of(context);
    final cubit = context.read<HomeScreenCubit>();
    final imageBytes = cubit.state.imageBytes!;
    return Column(
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
                  const SizedBox(height: 8),
                  BlocBuilder<HomeScreenCubit, HomeScreenState>(
                    buildWhen: (final previous, final current) => previous.generateImages != current.generateImages,
                    builder: (final context, final state) {
                      return CheckboxListTile(
                        title: Text(
                          'Generate images using OpenAI DALL·E',
                          style: theme.textTheme.bodyMedium,
                        ),
                        value: state.generateImages,
                        onChanged: (final value) {
                          return cubit.onGenerateImagesChanged(
                            generateImages: value ?? false,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
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
    ).animate().fade();
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
    final cubit = context.read<HomeScreenCubit>();
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
    final cubit = context.read<HomeScreenCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We need your OpenAI API key to generate the code and your GitHub personal token to store it in a Gist. '
          'Check the FAQs below to learn how to get them.',
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _openAIController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('OpenAI API key'),
            helperText: 'Pro-tip: set a monthly limit to your OpenAI account to avoid surprises.',
          ),
          onChanged: cubit.onOpenAiKeyChanged,
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _githubController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('GitHub personal token'),
            helperText: 'Only Gists read/write permission is required (used to load the code into DartPad).',
          ),
          onChanged: cubit.onGithubKeyChanged,
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        BlocBuilder<HomeScreenCubit, HomeScreenState>(
          buildWhen: (final previous, final current) => previous.storeApiKeys != current.storeApiKeys,
          builder: (final context, final state) {
            return CheckboxListTile(
              title: Text(
                'Remember my keys for next time',
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
        const SizedBox(height: 16),
        Center(
          child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
            builder: (final context, final state) {
              final canSubmit = (state.openAiKey?.isNotEmpty ?? false) && (state.githubKey?.isNotEmpty ?? false);
              return FilledButton(
                onPressed: canSubmit ? cubit.onApiKeysSubmitted : null,
                child: const Text('Generate code'),
              );
            },
          ),
        ),
      ],
    ).animate().fade();
  }
}

class _S4Generating extends StatelessWidget {
  const _S4Generating();

  @override
  Widget build(final BuildContext context) {
    final highlighter = getIt<Highlighter>();
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: SingleChildScrollView(
        reverse: true,
        child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          buildWhen: (final previous, final current) => previous.generatedCode != current.generatedCode,
          builder: (final context, final state) {
            return Text.rich(
              highlighter.highlight(state.generatedCode ?? ''),
              textAlign: TextAlign.start,
            );
          },
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  static const _items = [
    _HowItWorksItem(
      title: 'Upload a screenshot',
      content: 'Select or drag and drop a screenshot of the UI you want to convert to Flutter.\n'
          'It can be from a real app, a design, or even a drawing!',
    ),
    _HowItWorksItem(
      title: 'Additional instructions',
      content: 'Optionally, add some extra instructions to help the AI generate the code.\n'
          'For example, how the UI should behave when the user interacts with it.',
    ),
    _HowItWorksItem(
      title: 'Code generation',
      content: 'The app leverages the power of OpenAI GPT-4V(ision) multimodal LLM to '
          'transform your screenshot and instructions into code.',
    ),
    _HowItWorksItem(
      title: 'Run the code',
      content: 'The generated code is stored in a GitHub Gist and loaded into DartPad.\n'
          'So you can run the resulting Flutter app right from the browser!',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: theme.colorScheme.surface,
        margin: const EdgeInsets.only(top: 36),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1080),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How does it work?',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (final context, final constraints) {
                    final steps = Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (final context, final index) {
                            return _HowItWorksItemWidget(
                              step: index + 1,
                              item: _items[index],
                            );
                          },
                          itemCount: _items.length,
                        ),
                      ),
                    );
                    final illustration = Assets.howItWorks.svg(width: 250);
                    return constraints.maxWidth > 768
                        ? Row(
                            children: [
                              Expanded(child: steps),
                              const SizedBox(width: 64),
                              illustration,
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              steps,
                              const SizedBox(height: 32),
                              illustration,
                            ],
                          );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksItem {
  const _HowItWorksItem({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}

class _HowItWorksItemWidget extends StatelessWidget {
  const _HowItWorksItemWidget({
    required this.step,
    required this.item,
  });

  final int step;
  final _HowItWorksItem item;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                item.title,
                style: theme.textTheme.titleLarge,
              ),
              Text(
                item.content,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _FAQs extends StatelessWidget {
  const _FAQs();

  static const _faqs = [
    _FAQsItem(
      title: 'Is pixels2flutter.dev free?',
      content: 'Yes! [pixels2flutter.dev](https://pixels2flutter.dev) app is totally free.  \n'
          'But you need to provide your own OpenAI key to generate the code.  \n'
          r'Every generation costs around $0.05 of OpenAI credits.',
    ),
    _FAQsItem(
      title: 'Is pixels2flutter.dev open-source?',
      content: 'Yes! [pixels2flutter.dev](https://pixels2flutter.dev) app is fully open-source. '
          'It is built using Flutter web and [LangChain.dart](https://github.com/davidmigloz/langchain_dart).  \n'
          'You can find the code in [here](https://github.com/davidmigloz/pixels2flutter). '
          "Don't forget to give it a star if you like it!",
    ),
    _FAQsItem(
      title: 'Can I use an open-source alternative to OpenAI?',
      content:
          r'At the moment, [pixels2flutter.dev](https://pixels2flutter.dev) only supports OpenAI GPT-4V(ision) model. '
          r'But as soon as [LangChain.dart](https://github.com/davidmigloz/langchain_dart) supports other alternatives, '
          r'pixels2flutter will add support for them too.',
    ),
    _FAQsItem(
      title: 'Where can I get the OpenAI and GitHub API keys?',
      content: '**OpenAI key:**  \n'
          '1. Log in or sign up to the [OpenAI platform](https://platform.openai.com/docs/overview).\n'
          '2. Go to the [API keys page](https://beta.openai.com/account/api-keys).\n'
          '3. Click on the "Create new API key" button.\n'
          '4. Copy the key.\n'
          '5. *Recommended*: go to [Usage page](https://platform.openai.com/usage) and set a monthly limit to avoid surprises.\n\n'
          '**GitHub token:**  \n'
          '1. Log in or sign up to [GitHub](https://github.com).\n'
          '2. Go to the [Personal access tokens page](https://github.com/settings/tokens?type=beta).\n'
          '3. Select Fine-grained personal access tokens.\n'
          '4. Give it a name (e.g. pixels2flutter).\n'
          '5. Set the expiration date (e.g. 30 days).\n'
          '6. Repository access: Public Repositories (read-only).\n'
          '7. Permissions: select only Gists - Access: Read and Write.\n'
          '8. Click generate and copy the token.\n',
    ),
    _FAQsItem(
      title: "Isn't it risky to provide my API keys?",
      content:
          'Yes, it is. But that is the only way we can offer [pixels2flutter.dev](https://pixels2flutter.dev) app for free. '
          'That is also why it is open-source. You can check the code and run it locally if you want to be 100% sure '
          'that your API keys are not being misused.',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 48),
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Card(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'FAQs',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (final context, final index) {
                      return _FAQsItemWidget(item: _faqs[index]);
                    },
                    itemCount: _faqs.length,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FAQsItem {
  const _FAQsItem({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}

class _FAQsItemWidget extends StatefulWidget {
  const _FAQsItemWidget({
    required this.item,
  });

  final _FAQsItem item;

  @override
  State<_FAQsItemWidget> createState() => _FAQsItemWidgetState();
}

class _FAQsItemWidgetState extends State<_FAQsItemWidget> {
  late ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(
          Icons.double_arrow,
          size: 12,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            widget.item.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        expandedAlignment: Alignment.topLeft,
        children: <Widget>[
          Builder(
            builder: (final BuildContext context) {
              return Container(
                padding: const EdgeInsets.only(
                  left: 52,
                  right: 16,
                  bottom: 16,
                ),
                child: MarkdownBody(
                  data: widget.item.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  onTapLink: (final text, final href, final title) async {
                    await launchUrl(Uri.parse(href!));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Made with 💙 by David Miguel
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Made with ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Icon(
                      Icons.favorite,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ).animate(onPlay: (final c) => c.loop()).shimmer(
                          delay: 500.ms,
                          duration: 2000.ms,
                          color: theme.colorScheme.secondary,
                        ),
                    Text(
                      ' by ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Link(
                      uri: Uri.parse('https://www.linkedin.com/in/davidmigloz'),
                      target: LinkTarget.blank,
                      builder: (final context, final followLink) => InkWell(
                        onTap: followLink,
                        child: Text(
                          'David Miguel',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Flutter and the related logo are trademarks of Google LLC. We are not endorsed by or affiliated with Google LLC.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
