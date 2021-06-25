class User {
  int? id;
  String?username;
  bool? isConfirmed;
  int? newMessagesCount;

  User({this.id, this.username, this.isConfirmed, this.newMessagesCount});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    isConfirmed = json['is_confirmed'];
    newMessagesCount = json['new_messages_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['is_confirmed'] = this.isConfirmed;
    data['new_messages_count'] = this.newMessagesCount;
    return data;
  }
}