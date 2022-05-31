import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  String name;
  String url;
  final Reference ref;

  FirebaseFile({required this.name, required this.url, required this.ref});
}
