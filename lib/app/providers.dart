import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplikasi_berita/services/connectivity_notifier.dart';
import 'package:aplikasi_berita/services/ui_changes_notifier.dart';
import 'package:aplikasi_berita/services/firestore_service.dart';
import 'package:aplikasi_berita/services/storage_service.dart';
import 'package:aplikasi_berita/view_models/saved_articles_view_model.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider<FirestoreService?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  String? uid = auth.asData?.value?.uid;
  return uid != null ? FirestoreService(uid: uid) : null;
});

final pickImageProvider = StateProvider.autoDispose<XFile?>((_) => null);

final storageProvider = Provider<StorageService?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  String? uid = auth.asData?.value?.uid;
  if (uid != null) return StorageService(uid: uid);
  return null;
});

final uiChangesProvider =
    ChangeNotifierProvider.autoDispose((ref) => UIUpdatesNotifier());

final savedArticlesProvider = ChangeNotifierProvider<SavedArticlesViewModel>(
    (ref) => SavedArticlesViewModel());

final connectivityNotifierProvider =
    ChangeNotifierProvider<ConnectivityNotifier>(
        (ref) => ConnectivityNotifier());
