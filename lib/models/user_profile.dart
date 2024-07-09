// import 'dart:ffi';
//
// class UserProfile {
//   String? uid;
//   String? name;
//   String? pfpURL;
//
//   UserProfile({
//     required this.uid,
//     required this.name,
//     required this.pfpURL,
//   });
//
//   UserProfile.fromJson(Map<String, dynamic> json)
//       : uid = json['uid'],
//         name = json['name'],
//         pfpURL = json['pfpURL'];
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['uid'] = uid;
//     data['name'] = name;
//     data['pfpURL'] = pfpURL;
//     return data;
//   }
// }


class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  UserProfile({
    this.uid,
    this.name,
    this.pfpURL,
  });

  UserProfile.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        pfpURL = json['pfpURL'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    return data;
  }
}
