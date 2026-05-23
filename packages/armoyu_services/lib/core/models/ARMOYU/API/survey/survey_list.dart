import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APISurveyList {
  int surveyId;
  SurveyOwner surveyOwner;
  String surveyQuestion;
  List<Media> surveyMedia;
  String surveyType;
  int surveyStatus;
  String surveyEndDate;
  String surveyRemainingTime;
  double surveyVotingPercentage;
  int surveyVotingCount;
  List<SurveyOption> surveyOptions;
  int surveyDidIVote;
  int surveySelectedOption;

  APISurveyList({
    required this.surveyId,
    required this.surveyOwner,
    required this.surveyQuestion,
    required this.surveyMedia,
    required this.surveyType,
    required this.surveyStatus,
    required this.surveyEndDate,
    required this.surveyRemainingTime,
    required this.surveyVotingPercentage,
    required this.surveyVotingCount,
    required this.surveyOptions,
    required this.surveyDidIVote,
    required this.surveySelectedOption,
  });

  factory APISurveyList.fromJson(Map<String, dynamic> json) {
    return APISurveyList(
      surveyId: json['survey_ID'],
      surveyOwner: SurveyOwner.fromJson(json['survey_owner']),
      surveyQuestion: json['survey_question'],
      surveyMedia: (json['survey_media'] as List)
          .map((item) => Media.fromJson(item))
          .toList(),
      surveyType: json['survey_type'],
      surveyStatus: json['survey_status'],
      surveyEndDate: json['survey_enddate'],
      surveyRemainingTime: json['survey_remainingtime'],
      surveyVotingPercentage:
          (json['survey_votingPercentage'] as num).toDouble(),
      surveyVotingCount: json['survey_votingCount'],
      surveyOptions: (json['survey_options'] as List)
          .map((item) => SurveyOption.fromJson(item))
          .toList(),
      surveyDidIVote: json['survey_didIVote'],
      surveySelectedOption: json['survey_selectedOption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'survey_ID': surveyId,
      'survey_owner': surveyOwner.toJson(),
      'survey_question': surveyQuestion,
      'survey_media': surveyMedia.map((item) => item.toJson()).toList(),
      'survey_type': surveyType,
      'survey_status': surveyStatus,
      'survey_enddate': surveyEndDate,
      'survey_remainingtime': surveyRemainingTime,
      'survey_votingPercentage': surveyVotingPercentage,
      'survey_votingCount': surveyVotingCount,
      'survey_options': surveyOptions.map((item) => item.toJson()).toList(),
      'survey_didIVote': surveyDidIVote,
      'survey_selectedOption': surveySelectedOption,
    };
  }
}

// Survey Owner Sınıfı
class SurveyOwner {
  int ownerId;
  String ownerDisplayName;
  MediaURL ownerAvatar;

  SurveyOwner({
    required this.ownerId,
    required this.ownerDisplayName,
    required this.ownerAvatar,
  });

  factory SurveyOwner.fromJson(Map<String, dynamic> json) {
    return SurveyOwner(
      ownerId: json['owner_ID'],
      ownerDisplayName: json['owner_displayname'],
      ownerAvatar: MediaURL.fromJson(json['owner_avatar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_ID': ownerId,
      'owner_displayname': ownerDisplayName,
      'owner_avatar': ownerAvatar.toJson(),
    };
  }
}

// Survey Option Sınıfı
class SurveyOption {
  int optionId;
  String optionAnswer;
  double optionVotingPercentage;

  SurveyOption({
    required this.optionId,
    required this.optionAnswer,
    required this.optionVotingPercentage,
  });

  factory SurveyOption.fromJson(Map<String, dynamic> json) {
    return SurveyOption(
      optionId: json['option_ID'],
      optionAnswer: json['option_answer'],
      optionVotingPercentage: double.parse(json['option_votingPercentage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option_ID': optionId,
      'option_answer': optionAnswer,
      'option_votingPercentage': optionVotingPercentage.toString(),
    };
  }
}
