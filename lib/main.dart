import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_berita/app/pages/admin_home.dart';
import 'package:aplikasi_berita/app/pages/auth/sign_in_page.dart';
import 'package:aplikasi_berita/app/pages/auth_widget.dart';
import 'package:aplikasi_berita/app/pages/user/user_home.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ref.watch(connectivityNotifierProvider).connected
            ? AuthWidget(
                adminPanelBuilder: (context) => const AdminHome(),
                nonSignedInBuilder: (context) => const SignInPage(),
                signedInBuilder: (context) => const UserHome(),
              )
            : AuthWidget(
                adminPanelBuilder: (context) => const AdminHome(),
                nonSignedInBuilder: (context) => const SignInPage(),
                signedInBuilder: (context) => const UserHome(),
              ));
  }
}
