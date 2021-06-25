

class PrivacyPolicyDataResponse{
  final String? text;

  PrivacyPolicyDataResponse(
      {
        this.text,
      });

  factory PrivacyPolicyDataResponse.fromJson(Map<dynamic, dynamic> json) {
    return PrivacyPolicyDataResponse(
      text: json['text'],
    );
  }
}