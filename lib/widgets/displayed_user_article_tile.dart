import 'package:flutter/material.dart';
import 'package:aplikasi_berita/app/pages/user/article_detail.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/constants.dart';

class DisplayedUserArticleListTile extends StatelessWidget {
  const DisplayedUserArticleListTile({Key? key, required this.article})
      : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArticleDetail(
            article: article,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            article.imageUrl != uploadImageError
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: '${article.imageUrl}',
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
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.title,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.category,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 149, 149, 158),
                            fontSize: 14.0),
                      ),
                      Text(
                        article.timestamp,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 149, 149, 158),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
