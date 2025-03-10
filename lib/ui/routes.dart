import 'package:flutter_practical_16/ui/thoughts_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'message_screen.dart';

// GoRouter Configuration
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
        path: '/message',
        builder: (context, state) {
          final message = state.uri.queryParameters['message'] ?? '';
          return MessageScreen(message: message);
        },
      ),
    ],
    // Handle deep links
    redirect: (context, state) {
      // Handle deep link for opening the app with a message
      if (state.fullPath?.contains('open.my.app') == true) {
        final uri = Uri.parse(state.fullPath!);
        if (uri.queryParameters.containsKey('message')) {
          final message = uri.queryParameters['message'] ?? '';
          return '/message?message=$message';
        }
      }
      return null;
    },
  );
});