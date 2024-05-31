import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/constants.dart';
import 'package:aplikasi_berita/utils/snackbars.dart';
import 'package:aplikasi_berita/widgets/input_field.dart';

class AdminEditArticlePage extends ConsumerStatefulWidget {
  const AdminEditArticlePage({Key? key, required this.article})
      : super(key: key);

  final Article article;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminEditArticlePageState();
}

class _AdminEditArticlePageState extends ConsumerState<AdminEditArticlePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.article.title;
    descriptionController.text = widget.article.description;
    ref.read(uiChangesProvider).setArticleCategory(widget.article.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit the Article'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomInputField(
                  inputController: titleController,
                  hintText: "Article's title",
                  labelText: "Article's title",
                ),
                const SizedBox(height: 15),
                CustomInputField(
                  inputController: descriptionController,
                  hintText: "Article's description",
                  labelText: "Article's description",
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Article's category: ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Consumer(
                      builder: (context, ref, child) {
                        final dropdownProvider = ref.watch(uiChangesProvider);
                        return DropdownButton<String>(
                          value: dropdownProvider.articleCategory,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.black54,
                          ),
                          underline: Container(
                            height: 1,
                            color: Colors.black45,
                          ),
                          onChanged: (newValue) {
                            dropdownProvider.setArticleCategory('$newValue');
                          },
                          items: categoriesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Consumer(
                  builder: (context, ref, child) {
                    final image = ref.watch(pickImageProvider);
                    return image == null
                        ? Image.network(
                            widget.article.imageUrl!,
                            key: UniqueKey(),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : Container(
                                      color: Colors.black12,
                                      height: 200,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                              child: Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.black38,
                              ),
                            ),
                          )
                        : Image.network(
                            image.path,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: const Text(
                    'Pick an image',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
                  onTap: () async {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      ref.watch(pickImageProvider.state).state = image;
                    }
                  },
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, child) {
                    final loadingNotifier = ref.watch(uiChangesProvider);
                    return loadingNotifier.loading
                        ? const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              ref.read(uiChangesProvider).isLoading(true);
                              _editArticle();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                            ),
                            child: const Text('Edit the article'),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editArticle() async {
    final firestoreDB = ref.read(databaseProvider);
    final imagePicker = ref.read(pickImageProvider);
    final storage = ref.read(storageProvider);
    final category = ref.read(uiChangesProvider).articleCategory;

    if (firestoreDB == null || storage == null) return;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    if (imagePicker != null) {
      final url = await storage.uploadImage(imagePicker.path);

      await firestoreDB.editArticle(
          Article(
              title: titleController.text,
              description: descriptionController.text,
              category: category,
              imageUrl: url,
              timestamp: formattedDate,
              id: widget.article.id),
          widget.article.category);
    } else {
      await firestoreDB.editArticle(
          Article(
              title: titleController.text,
              description: descriptionController.text,
              category: category,
              timestamp: formattedDate,
              id: widget.article.id),
          widget.article.category);
    }
    openIconSnackBar(
      context,
      'Edited the article',
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}
