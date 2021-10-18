class Item {
  final int? id;
  final String name;
  final int status;

  Item(
      { this.id,
        required this.name,
        required this.status
        });

  Item.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        status = res["status"];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name, 'status': status};
  }
}