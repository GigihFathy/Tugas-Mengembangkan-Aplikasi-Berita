import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_berita/app/pages/admin_add_article.dart';
import 'package:aplikasi_berita/app/pages/admin_edit_article.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/snackbars.dart';
import 'package:aplikasi_berita/widgets/article_list_tile.dart';
import 'package:aplikasi_berita/widgets/empty_widget.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(firebaseAuthProvider).signOut(),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 28, 28),
        elevation: 0,
      ),
      body: StreamBuilder<List<Article>>(
        stream: ref.watch(databaseProvider)!.getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return const EmptyWidget();
            }
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Article article = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ArticleListTile(
                      article: article,
                      onDelete: () {
                        ref.read(databaseProvider)!.deleteArticle(article.id!);
                        ref.read(databaseProvider)!.deleteArticleFromCategories(
                            article.id!, article.category);
                        ref
                            .read(storageProvider)!
                            .deleteImage(article.imageUrl!);
                        openIconSnackBar(
                            context,
                            'Deleted the article',
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                            ));
                      },
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdminEditArticlePage(
                            article: article,
                          ),
                        ));
                      },
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AdminAddArticlePage()))),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
