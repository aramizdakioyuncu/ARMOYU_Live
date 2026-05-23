class Sitemessage {
  final bool status;
  final int currentMembers;
  final int onlineMembers;
  final int chatcount;
  final int avaiblepolls;
  final int avaibleEvents;
  final int avaiblegroupEvents;
  final int downloads;
  final int friendrequests;
  final int grouprequests;

  // Constructor
  Sitemessage({
    required this.status,
    required this.currentMembers,
    required this.onlineMembers,
    required this.chatcount,
    required this.avaiblepolls,
    required this.avaibleEvents,
    required this.avaiblegroupEvents,
    required this.downloads,
    required this.friendrequests,
    required this.grouprequests,
  });

  // JSON'dan nesneye dönüştürme
  factory Sitemessage.fromJson(Map<String, dynamic> json) {
    return Sitemessage(
      status: json['status'],
      currentMembers: json['currentMembers'],
      onlineMembers: json['onlineMembers'],
      chatcount: json['chatcount'],
      avaiblepolls: json['avaiblepolls'],
      avaibleEvents: json['avaibleEvents'],
      avaiblegroupEvents: json['avaiblegroupEvents'],
      downloads: json['downloads'],
      friendrequests: json['friendrequests'],
      grouprequests: json['grouprequests'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'currentMembers': currentMembers,
      'onlineMembers': onlineMembers,
      'chatcount': chatcount,
      'avaiblepolls': avaiblepolls,
      'avaibleEvents': avaibleEvents,
      'avaiblegroupEvents': avaiblegroupEvents,
      'downloads': downloads,
      'friendrequests': friendrequests,
      'grouprequests': grouprequests,
    };
  }
}
