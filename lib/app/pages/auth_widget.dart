import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/user_data.dart';
import 'package:aplikasi_berita/utils/constants.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
    required this.adminPanelBuilder,
  }) : super(key: key);

  final WidgetBuilder signedInBuilder;
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder adminPanelBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return authStateChanges.when(
        data: (user) {
          final userEmail = user?.email?.trim();
          print('User email: $userEmail');
          print('Admin email: $adminEmail');

          if (user != null) {
            if (userEmail == adminEmail) {
              return adminPanelBuilder(context);
            } else {
              return signedInHandler(context, ref, user);
            }
          } else {
            return nonSignedInBuilder(context);
          }
        },
        error: (_, __) => const Center(
              child: Text('Something went wrong'),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  FutureBuilder<UserData?> signedInHandler(
      BuildContext context, WidgetRef ref, User user) {
    final firestoreDatabaseProvider = ref.watch(databaseProvider)!;
    return FutureBuilder(
        future: firestoreDatabaseProvider.getUser(user.uid),
        builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              firestoreDatabaseProvider.addUser(UserData(
                  uid: user.uid, email: user.email != null ? user.email! : ""));
            }
            return signedInBuilder(context);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
