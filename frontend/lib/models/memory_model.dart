class MemoryEntry {
  final String id;
  final String content; // This is the AI-generated 1-2 sentence summary
  final String sourceType; // 'resume', 'linkedin', 'freeform', etc.
  final String sourceFilename;
  final String category; // 'experience', 'skill', 'education', etc.
  final DateTime createdAt;

  MemoryEntry({
    required this.id,
    required this.content,
    required this.sourceType,
    required this.sourceFilename,
    required this.category,
    required this.createdAt,
  });

  factory MemoryEntry.fromJson(Map<String, dynamic> json) {
    return MemoryEntry(
      id: json['id'] as String,
      content: json['content'] as String,
      sourceType: json['source_type'] as String,
      sourceFilename: json['source_filename'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'source_type': sourceType,
      'source_filename': sourceFilename,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
