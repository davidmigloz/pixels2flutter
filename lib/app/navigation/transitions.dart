import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<void> noTransitionPage({
  required final GoRouterState state,
  required final Widget child,
}) {
  assert(state.name != null);
  return NoTransitionPage(
    key: state.pageKey,
    name: state.name,
    arguments: {...state.pathParameters, ...state.uri.queryParameters},
    restorationId: state.pageKey.value,
    child: child,
  );
}
