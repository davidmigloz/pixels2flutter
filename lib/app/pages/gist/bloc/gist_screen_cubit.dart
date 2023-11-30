import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/domain.dart';

part 'gist_screen_state.dart';

@injectable
class GistScreenCubit extends Cubit<GistScreenState> {
  GistScreenCubit(
    @factoryParam final String gistId,
    this._deleteGistUseCase,
    this._router,
  ) : super(GistScreenState(gistId: gistId));

  final DeleteGistUseCase _deleteGistUseCase;
  final GoRouter _router;

  Future<void> onDeleteGistPressed() async {
    _router.pop();
    await _deleteGistUseCase(
      params: DeleteGistUseCaseParams(gistId: state.gistId),
    );
  }
}
