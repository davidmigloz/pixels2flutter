import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../assets/assets.gen.dart';
import 'bloc/home_page_cubit.dart';

class HomePageExamplesSection extends StatelessWidget {
  const HomePageExamplesSection({super.key});

  static const _examples = [
    _Example(
      title: 'Screenshot',
      description: 'Convert a screenshot of a real app to Flutter code.',
      original: Assets.exampleYoutube,
      originalWidth: 200,
      generated: Assets.exampleYoutubeGenerated,
      generatedWidth: 200,
    ),
    _Example(
      title: 'Wireframe',
      description: 'Convert a wireframe to Flutter code.',
      original: Assets.exampleWireframe,
      originalWidth: 400,
      generated: Assets.exampleWireframeGenerated,
      generatedWidth: 200,
    ),
    _Example(
      title: 'Game',
      description: 'Convert a screenshot of a game plus a description of its logic to a playable Flutter game.',
      original: Assets.examplePingPong,
      originalWidth: 350,
      generated: Assets.examplePingpongGenerated,
      generatedWidth: 350,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 48),
          constraints: const BoxConstraints(maxWidth: 960),
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
                    'Examples',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  const _ExampleSelector(_examples),
                  const SizedBox(height: 16),
                  const _ExampleWidget(_examples),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleSelector extends StatelessWidget {
  const _ExampleSelector(this.examples);

  final List<_Example> examples;

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    return BlocBuilder<HomePageCubit, HomePageState>(
      buildWhen: (final previous, final current) => previous.selectedExample != current.selectedExample,
      builder: (final context, final state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            for (final (index, example) in examples.indexed) ...[
              ChoiceChip(
                label: Text(example.title),
                selected: state.selectedExample == index,
                showCheckmark: false,
                onSelected: (final _) => cubit.onExampleSelected(index),
              ),
              const SizedBox(width: 8),
            ],
          ],
        );
      },
    );
  }
}

class _ExampleWidget extends StatelessWidget {
  const _ExampleWidget(this.examples);

  final List<_Example> examples;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<HomePageCubit, HomePageState>(
      buildWhen: (final previous, final current) => previous.selectedExample != current.selectedExample,
      builder: (final context, final state) {
        final example = examples[state.selectedExample];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              color: Colors.grey.shade300,
              strokeWidth: 2,
              dashPattern: const [6, 3],
              radius: const Radius.circular(16),
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 420),
                child: LayoutBuilder(
                  builder: (final context, final constraints) {
                    final original = ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: example.original.image(width: example.originalWidth),
                    );
                    final generated = ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: example.generated.image(width: example.generatedWidth),
                    );
                    return constraints.maxWidth > 768
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),
                              original,
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              const Spacer(),
                              generated,
                              const Spacer(flex: 2),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              original,
                              const SizedBox(height: 16, width: double.infinity),
                              Icon(
                                Icons.arrow_downward_rounded,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(height: 16),
                              generated,
                            ],
                          );
                  },
                ).animate(key: UniqueKey()).fade(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              example.description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}

class _Example {
  const _Example({
    required this.title,
    required this.description,
    required this.original,
    required this.originalWidth,
    required this.generated,
    required this.generatedWidth,
  });

  final String title;
  final String description;
  final AssetGenImage original;
  final double originalWidth;
  final AssetGenImage generated;
  final double generatedWidth;
}
