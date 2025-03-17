class Label {
  int? id;
  String name;
  String icon;
  String color;
  int editable;
  int deletable;
  int deleted;

  Label({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.editable = 1,
    this.deletable = 1,
    this.deleted = 0,
  });

  factory Label.fromMap(Map<String, dynamic> json) => Label(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        color: json['color'],
        editable: json['editable'],
        deletable: json['deletable'],
        deleted: json['deleted'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'editable': editable,
      'deletable': deletable,
      'deleted': deleted,
    };
  }
}
