import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/thought_model.dart';
import 'package:flutter/animation.dart';

class MessageScreen extends StatelessWidget {
  final String message;

  const MessageScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate a background gradient based on message length
    final int messageLength = message.length;
    final Color startColor = HSLColor.fromAHSL(
        1.0,
        (messageLength * 2) % 360,
        0.7,
        0.7
    ).toColor();

    final Color endColor = HSLColor.fromAHSL(
        1.0,
        ((messageLength * 3) % 360),
        0.7,
        0.5
    ).toColor();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.go('/'),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.format_quote,
                              size: 48,
                              color: Colors.indigo,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 22,
                                height: 1.5,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.3 + (i * 0.2)),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add this message as a thought
                        final thought = Thought(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          content: message,
                          timestamp: DateTime.now(),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save as Thought'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}