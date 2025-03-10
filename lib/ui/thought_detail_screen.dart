import 'package:flutter/material.dart';
import 'package:flutter_practical_16/ui/thoughts_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/thought_model.dart';

class ThoughtDetailScreen extends ConsumerWidget {
  final String thoughtId;

  const ThoughtDetailScreen({Key? key, required this.thoughtId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thoughtsAsyncValue = ref.watch(thoughtsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thought Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: thoughtsAsyncValue.when(
        data: (thoughts) {
          final thought = thoughts.firstWhere(
                (t) => t.id == thoughtId,
            orElse: () => Thought(
              id: '',
              content: 'Thought not found',
              timestamp: DateTime.now(),
            ),
          );

          if (thought.id.isEmpty) {
            return const Center(child: Text('Thought not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Created on ${_formatDateDetailed(thought.timestamp)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          thought.content,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/message?message=${thought.content}');
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Show as Message'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading thought: $err'),
        ),
      ),
    );
  }

  String _formatDateDetailed(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}