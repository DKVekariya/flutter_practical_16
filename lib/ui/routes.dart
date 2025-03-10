import 'package:flutter_practical_16/ui/thoughts_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ThoughtsScreen(),
      ),
      GoRoute(
        path: '/thought/:id',
        builder: (context, state) {
          final thoughtId = state.pathParameters['id'] ?? '';
          return ThoughtDetailScreen(thoughtId: thoughtId);
        },
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) {
          final message = state.uri.queryParameters['message'] ?? '';
          return ThoughtsScreen(initialMessage: message);
        },
      ),
      GoRoute(
        path: '/:message',
        builder: (context, state) {
          final message = state.pathParameters['message'] ?? '';
          return ThoughtDetailScreen(thoughtId: message);
        },
      ),
    ],

  );
});