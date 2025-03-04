import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aplikasi_berita/utils/constants.dart';

class StorageService {
  final String uid;
  StorageService({required this.uid});

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(String filePath) async {
    try {
      final dateTime = DateTime.now().toIso8601String();
      final ref = storage.ref('$uid/$dateTime');
      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return uploadImageError;
    }
  }

  Future<void> deleteImage(String filePath) async {
    try {
      await storage.refFromURL(filePath).delete();
    } catch (e) {
      //image delete error
    }
  }
}
