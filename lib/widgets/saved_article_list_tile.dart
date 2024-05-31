import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:aplikasi_berita/app/pages/user/article_detail.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/constants.dart';
import 'package:aplikasi_berita/utils/snackbars.dart';

class SavedArticleListTile extends ConsumerWidget {
  const SavedArticleListTile({Key? key, required this.article})
      : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: const Key('0'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              ref.read(savedArticlesProvider).removeArticle(article);
              ref.read(databaseProvider)!.removeFavoriteArticle(article);
              openIconSnackBar(
                context,
                'Deleted from saved',
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ArticleDetail(article: article)));
        },
        child: ListTile(
          leading: article.imageUrl != uploadImageError
              ? Hero(
                  tag: '${article.imageUrl}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl!,
                      key: UniqueKey(),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : Container(
                                color: Colors.black12,
                                height: 80,
                                width: 80,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black12,
                        height: 80,
                        width: 80,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              : const Text('No image found!'),
          title: Text(
            article.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(article.category),
              Text(article.timestamp),
            ],
          ),
        ),
      ),
    );
  }
}
