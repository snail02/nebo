

class AuthLoginDataResponse{
  final String? token;
  final String? detail;

  AuthLoginDataResponse(
      {
        this.token,
        this.detail,
      });

  factory AuthLoginDataResponse.fromJson(Map<dynamic, dynamic> json) {
    return AuthLoginDataResponse(
      token: (json['token']!=null)? json['token'] : null,
      detail: (json['detail']!=null)? json['detail'] : null,
    );
  }
}