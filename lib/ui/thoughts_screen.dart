import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/thought_model.dart';
import '../data/thought_service.dart';

// Providers
final thoughtsApiServiceProvider = Provider<ThoughtsApiService>((ref) {
  return ThoughtsApiService();
});

final thoughtsProvider = FutureProvider<List<Thought>>((ref) async {
  final apiService = ref.watch(thoughtsApiServiceProvider);
  return apiService.getThoughts();
});

final newThoughtProvider = StateProvider<String>((ref) => '');

class ThoughtsScreen extends ConsumerStatefulWidget {
  final String initialMessage;

  const ThoughtsScreen({super.key, this.initialMessage = ''});

  @override
  _ThoughtsScreenState createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends ConsumerState<ThoughtsScreen> {
  late TextEditingController _thoughtController;

  @override
  void initState() {
    super.initState();
    _thoughtController = TextEditingController(text: widget.initialMessage);
    if (widget.initialMessage.isNotEmpty) {
      // Update the provider state with the initial message from deep link
      Future.microtask(() {
        ref.read(newThoughtProvider.notifier).state = widget.initialMessage;
      });
    }
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  void _saveThought() async {
    final newThoughtContent = ref.read(newThoughtProvider);
    if (newThoughtContent.trim().isEmpty) return;

    final newThought = Thought(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: newThoughtContent,
      timestamp: DateTime.now(),
    );

    final apiService = ref.read(thoughtsApiServiceProvider);
    await apiService.saveThought(newThought);

    // Clear the input field
    _thoughtController.clear();
    ref.read(newThoughtProvider.notifier).state = '';

    // Refresh the thoughts list
    ref.refresh(thoughtsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final newThought = ref.watch(newThoughtProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Thoughts Journal'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _thoughtController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your thoughts...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ref.read(newThoughtProvider.notifier).state = value;
                    },
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveThought,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final thoughtsAsyncValue = ref.watch(thoughtsProvider);

                return thoughtsAsyncValue.when(
                  data: (thoughts) {
                    if (thoughts.isEmpty) {
                      return const Center(
                        child: Text('No thoughts yet. Add your first one!'),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: thoughts.length,
                      itemBuilder: (context, index) {
                        final thought = thoughts[thoughts.length - 1 - index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to detail screen
                            context.go('/thought/${thought.id}');
                          },
                          child: ThoughtCard(thought: thought),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text('Error loading thoughts: $err'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Card widget for displaying a thought
class ThoughtCard extends StatelessWidget {
  final Thought thought;

  const ThoughtCard({Key? key, required this.thought}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                thought.content,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(thought.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Detail screen to view a single thought
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
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created on ${_formatDateDetailed(thought.timestamp)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
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