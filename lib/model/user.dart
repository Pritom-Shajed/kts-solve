class User {
  String id;
  final String name;

  User({this.id = '', required this.name});
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
  static User fromJson(Map<String, dynamic> json) =>
      User(name: json['name'], id: json['id']);
}
class Post {
  final String title;
  final String description;
  final List<String> imageUrls;

  Post({required this.title, required this.description, required this.imageUrls});

  static fromMap(Map<String, dynamic> postData, List<String> imageUrls) {}
}
