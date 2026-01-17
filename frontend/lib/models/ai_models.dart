// AI Processing Request and Response Models
//
// These models define the data structures for communicating with the backend
// AI processing endpoints (/ai/process, /ai/structure, etc.)

/// Request model for AI processing
class ProcessRequest {
  final String audioUrl;
  final String storyId;
  final String userId;
  final String? rawTranscript; // Optional: skip transcription if provided

  ProcessRequest({
    required this.audioUrl,
    required this.storyId,
    required this.userId,
    this.rawTranscript,
  });

  Map<String, dynamic> toJson() => {
        'audio_url': audioUrl,
        'story_id': storyId,
        'user_id': userId,
        if (rawTranscript != null) 'raw_transcript': rawTranscript,
      };
}

/// Individual tag assignment with confidence and reasoning from AI
class TagAssignment {
  final String tag;
  final double confidence;
  final String reasoning;

  TagAssignment({
    required this.tag,
    required this.confidence,
    required this.reasoning,
  });

  factory TagAssignment.fromJson(Map<String, dynamic> json) {
    return TagAssignment(
      tag: json['tag'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'confidence': confidence,
        'reasoning': reasoning,
      };
}

/// Individual coaching insight with overview and detail
class CoachingInsight {
  final String overview; // 1-2 sentence summary
  final String detail; // Detailed paragraph

  CoachingInsight({
    required this.overview,
    required this.detail,
  });

  factory CoachingInsight.fromJson(Map<String, dynamic> json) {
    return CoachingInsight(
      overview: json['overview'] ?? '',
      detail: json['detail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'overview': overview,
        'detail': detail,
      };
}

/// Complete coaching insights (strength, gap, suggestion)
class CoachingInsights {
  final CoachingInsight strength;
  final CoachingInsight gap;
  final CoachingInsight suggestion;

  CoachingInsights({
    required this.strength,
    required this.gap,
    required this.suggestion,
  });

  factory CoachingInsights.fromJson(Map<String, dynamic> json) {
    return CoachingInsights(
      strength: json['strength'] != null
          ? CoachingInsight.fromJson(json['strength'])
          : CoachingInsight(overview: '', detail: ''),
      gap: json['gap'] != null
          ? CoachingInsight.fromJson(json['gap'])
          : CoachingInsight(overview: '', detail: ''),
      suggestion: json['suggestion'] != null
          ? CoachingInsight.fromJson(json['suggestion'])
          : CoachingInsight(overview: '', detail: ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'strength': strength.toJson(),
        'gap': gap.toJson(),
        'suggestion': suggestion.toJson(),
      };
}

/// Wrapper class that includes both the AI processing result and the audio URL
///
/// The audio URL is needed to save the story to Firestore, but is not included
/// in the backend's ProcessedStoryResponse since it was part of the request.
class ProcessingResult {
  final ProcessedStoryResponse aiResult;
  final String audioUrl;

  ProcessingResult({
    required this.aiResult,
    required this.audioUrl,
  });
}

/// Response from /ai/process endpoint
/// Contains complete processed story data from AI pipeline
class ProcessedStoryResponse {
  final String title;
  final String rawTranscript;
  final String? rawTranscriptUrl;
  final String problem;
  final String action;
  final String result;
  final List<TagAssignment> tags;
  final CoachingInsights coaching;
  final double confidenceScore;
  final List<String> warnings; // For partial failures

  ProcessedStoryResponse({
    required this.title,
    required this.rawTranscript,
    this.rawTranscriptUrl,
    required this.problem,
    required this.action,
    required this.result,
    required this.tags,
    required this.coaching,
    required this.confidenceScore,
    required this.warnings,
  });

  factory ProcessedStoryResponse.fromJson(Map<String, dynamic> json) {
    return ProcessedStoryResponse(
      title: json['title'] ?? 'Untitled Story',
      rawTranscript: json['raw_transcript'] ?? '',
      rawTranscriptUrl: json['raw_transcript_url'],
      problem: json['problem'] ?? '',
      action: json['action'] ?? '',
      result: json['result'] ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((t) => TagAssignment.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      coaching: json['coaching'] != null
          ? CoachingInsights.fromJson(json['coaching'])
          : CoachingInsights(
              strength: CoachingInsight(overview: '', detail: ''),
              gap: CoachingInsight(overview: '', detail: ''),
              suggestion: CoachingInsight(overview: '', detail: ''),
            ),
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((w) => w.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'raw_transcript': rawTranscript,
        if (rawTranscriptUrl != null) 'raw_transcript_url': rawTranscriptUrl,
        'problem': problem,
        'action': action,
        'result': result,
        'tags': tags.map((t) => t.toJson()).toList(),
        'coaching': coaching.toJson(),
        'confidence_score': confidenceScore,
        'warnings': warnings,
      };
}
