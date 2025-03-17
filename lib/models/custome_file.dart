class CustomerFile {
  int? id;
  int customerId;
  int fileId;

  CustomerFile({this.id, required this.customerId, required this.fileId});

  factory CustomerFile.fromMap(Map<String, dynamic> json) => CustomerFile(
        id: json['id'],
        customerId: json['customer_id'],
        fileId: json['file_id'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'file_id': fileId,
    };
  }
}
