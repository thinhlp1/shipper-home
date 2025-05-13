class Customer {
  int? id;
  String? name;
  String phone;
  String note;
  String map;
  String address;
  int deleted;
  bool isFavorite;
  int position;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> imageUrl;

  bool isNew = false;

  Customer({
    this.id,
    this.name,
    required this.phone,
    required this.note,
    required this.map,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.position = 0,
    this.deleted = 0,
    this.isFavorite = false,
    this.isNew = false,
    List<String>? imageUrl,
  }) : imageUrl = imageUrl ?? [];

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'] ?? "",
        phone: json['phone'] ?? "",
        note: json['note'] ?? "",
        map: json['map'] ?? "",
        address: json['address'] ?? "",
        position: json['position'] ?? 0,
        deleted: json['deleted'] ?? 0,
        isFavorite: (json['is_favorite'] ?? 0) == 1,
        imageUrl: [],
        createdAt: json['created_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'] * 1000)
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'note': note,
      'map': map,
      'address': address,
      'deleted': deleted,
      'position': position,
      'is_favorite': isFavorite ? 1 : 0, // Chuyển bool thành int
      'created_at': createdAt.millisecondsSinceEpoch ~/ 1000,
      'updated_at': updatedAt.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
