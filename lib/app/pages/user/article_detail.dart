import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/snackbars.dart';
import 'package:aplikasi_berita/widgets/user_top_bar.dart';

class ArticleDetail extends ConsumerWidget {
  const ArticleDetail({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: [
            UserTopBar(
              leadingIconButton: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              bookmarkIconButton: IconButton(
                icon: StreamBuilder(
                  stream: ref
                      .watch(databaseProvider)!
                      .checkIfArticleSavedStream(article.id!),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == null ||
                        !(snapshot.hasData) ||
                        !(snapshot.data!.exists)) {
                      return const Icon(Icons.bookmark_border);
                    }
                    return const Icon(Icons.bookmark);
                  },
                ),
                onPressed: () {
                  ref
                      .watch(databaseProvider)!
                      .checkIfArticleSaved(article.id!)
                      .then((isArticleSaved) {
                    if (isArticleSaved) {
                      ref
                          .read(databaseProvider)!
                          .removeFavoriteArticle(article);
                      ref.read(savedArticlesProvider).removeArticle(article);
                      openIconSnackBar(
                          context,
                          'Removed the article from favorites',
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                          ));
                    } else {
                      ref.read(databaseProvider)!.saveFavoriteArticle(article);
                      ref.read(savedArticlesProvider).addArticle(article);
                      openIconSnackBar(
                          context,
                          'Added the article to favorites',
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                          ));
                    }
                  });
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Hero(
              tag: '${article.imageUrl}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.network(
                  article.imageUrl!,
                  key: UniqueKey(),
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Container(
                            color: Colors.black12,
                            height: 300,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    child: Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              article.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.category,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 149, 149, 158),
                      fontSize: 16.0),
                ),
                Text(
                  article.timestamp,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 149, 149, 158),
                      fontWeight: FontWeight.w300,
                      fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              article.description, // Isi konten
              style: const TextStyle(fontSize: 18.0),
            ),
          ]),
        ),
      ),
    );
  }
}
