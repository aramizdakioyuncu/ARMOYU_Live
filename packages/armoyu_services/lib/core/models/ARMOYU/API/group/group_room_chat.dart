class GroupRoomChat {
  final int chatID;
  int owner;
  int sender;
  String content;
  String date;
  int? chatReply; // Eğer bir mesaj yanıtsa, chatID'sini tutar.

  GroupRoomChat({
    required this.chatID,
    required this.owner,
    required this.sender,
    required this.content,
    required this.date,
    this.chatReply,
  });

  factory GroupRoomChat.fromJson(Map<String, dynamic> json) {
    return GroupRoomChat(
      chatID: json['chatID'] as int,
      owner: json['owner'] as int,
      sender: json['sender'] as int,
      content: json['content'] as String,
      date: json['date'] as String,
      chatReply: json['chatReply'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'owner': owner,
      'sender': sender,
      'content': content,
      'date': date, // ISO formatında string dönüşümü
      'chatReply': chatReply,
    };
  }
}
