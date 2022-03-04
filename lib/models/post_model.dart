class Post{

  late String userId;
  late String title;
  late String content;
  late String image_url;
  late String key;

  Post(this.userId, this.title, this.content, this.image_url);

  Post.fromJson(Map<dynamic, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    content = json['content'];
    image_url = json['image_url'];
    key = json['key'];
  }

  Map<dynamic, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'content': content,
    'image_url': image_url,
  };
}

List<Post> posts = [];
List<String> keys = [];
