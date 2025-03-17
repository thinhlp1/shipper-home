class UserLabel {
  int? id;
  String username;
  int labelId;

  UserLabel({this.id, required this.username, required this.labelId});

  factory UserLabel.fromMap(Map<String, dynamic> json) => UserLabel(
        id: json['id'],
        username: json['username'],
        labelId: json['lable_id'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'lable_id': labelId,
    };
  }
}
