class StoryModel {
  final String id;
  final String userId;
  final String title;
  final String rawTranscript;
  final String problem;
  final String action;
  final String result;
  final List<String> tags;
  final CoachingModel? coaching;
  final String status; // "draft" | "complete"
  final DateTime createdAt;
  final DateTime updatedAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.rawTranscript,
    required this.problem,
    required this.action,
    required this.result,
    required this.tags,
    this.coaching,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['story_id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? 'Untitled Story',
      rawTranscript: json['rawTranscript'] ?? '',
      problem: json['problem'] ?? '',
      action: json['action'] ?? '',
      result: json['result'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      coaching: json['coaching'] != null
          ? CoachingModel.fromJson(json['coaching'])
          : null,
      status: json['status'] ?? 'draft',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }
}

class CoachingModel {
  final String strength;
  final String gap;
  final String suggestion;

  CoachingModel({
    required this.strength,
    required this.gap,
    required this.suggestion,
  });

  factory CoachingModel.fromJson(Map<String, dynamic> json) {
    return CoachingModel(
      strength: json['strength'] ?? '',
      gap: json['gap'] ?? '',
      suggestion: json['suggestion'] ?? '',
    );
  }
}
