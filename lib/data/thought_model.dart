class Thought {
  final String id;
  final String content;
  final DateTime timestamp;

  Thought({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  factory Thought.fromJson(Map<String, dynamic> json) {
    return Thought(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
