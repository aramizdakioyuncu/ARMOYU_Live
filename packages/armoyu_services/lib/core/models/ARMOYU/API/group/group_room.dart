class GroupRoom {
  final int roomID;
  int owner;
  String name;
  RoomType type;
  String? description;
  int? limit;
  Map<String, dynamic>? options;

  GroupRoom({
    required this.roomID,
    required this.owner,
    required this.name,
    required this.type,
    this.description,
    this.limit,
    this.options,
  });

  factory GroupRoom.fromJson(Map<String, dynamic> json) {
    return GroupRoom(
      roomID: json['roomID'] as int,
      owner: json['owner'] as int,
      name: json['name'] as String,
      type: RoomType.values.byName(json['type']), // String'ten Enum'a çeviri
      description: json['description'] as String?,
      limit: json['limit'] as int?,
      options: json['options'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'owner': owner,
      'name': name,
      'type': type.name, // Enum'u String'e çevirme
      'description': description,
      'limit': limit,
      'options': options,
    };
  }
}

enum RoomType {
  sound, // Sesli sohbet grubu
  text, // Yazılı sohbet grubu
}
