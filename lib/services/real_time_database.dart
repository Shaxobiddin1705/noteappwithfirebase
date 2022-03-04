import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:noteappwithfirebase/models/post_model.dart';

class RTDService {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream> addPost(Post post) async {
    _database.child('posts').push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<Stream> updatePost({required title, required content, required key}) async{
    await _database.child('posts').child(key).update({
      'title' : title,
      'content': content
    });
    return _database.onChildAdded;
  }

  static Future<void> deletePost({required key}) async{
    await _database.child('posts').child(key).remove();
  }

  static Future<List<Post>> getPosts(String userId) async {
    List<Post> items = [];
    Query _query = _database.child('posts').orderByChild('userId').equalTo(userId);
    var result = await _query.once();
    // var response = result.snapshot.children;
    items = result.snapshot.children.map((e) {
      Map<String, dynamic> post = Map<String, dynamic>.from(e.value as Map);
      post['key'] = e.key;
      return Post.fromJson(post);
    }).toList();
    // post = result.snapshot.children.map((json) => Post.fromJson(Map<String, dynamic>.from(json.value as Map))).toList();
    return items;
  }
}
