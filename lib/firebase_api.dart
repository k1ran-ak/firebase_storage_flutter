import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_flutter/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static Future<List<FirebaseFile>> listAll(String ref) async {
    final reference = FirebaseStorage.instance.ref().child(ref);
    final result = await reference.listAll();
    final urls = await getDownloadUrls(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(name: name, url: url, ref: ref);
          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future<List<FirebaseFile>> listOnly(String category) async {
    final reference = FirebaseStorage.instance.ref().child(category);
    final result = await reference.listAll();
    final urls = await getDownloadUrls(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(name: name, url: url, ref: ref);
          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future<List<String>> getDownloadUrls(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
}
