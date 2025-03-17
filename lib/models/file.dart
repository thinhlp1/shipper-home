class File {
  int? id;
  String link;
  String name;
  String extention;
  int size;

  File({
    this.id,
    required this.link,
    required this.name,
    required this.extention,
    required this.size,
  });

  factory File.fromMap(Map<String, dynamic> json) => File(
        id: json['id'],
        link: json['link'],
        name: json['name'],
        extention: json['extention'],
        size: json['size'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
      'name': name,
      'extention': extention,
      'size': size,
    };
  }
}
