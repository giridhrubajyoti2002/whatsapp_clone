class UserModel {
  final String name;
  final String uid;
  final String profilePicUrl;
  final String lastSeen;
  final String phoneNumber;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePicUrl,
    required this.lastSeen,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePicUrl': profilePicUrl,
      'lastSeen': lastSeen,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      lastSeen: map['lastSeen'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
