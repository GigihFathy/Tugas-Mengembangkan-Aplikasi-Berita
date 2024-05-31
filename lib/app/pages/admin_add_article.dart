import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/models/article.dart';
import 'package:aplikasi_berita/utils/constants.dart';
import 'package:aplikasi_berita/utils/snackbars.dart';
import 'package:aplikasi_berita/widgets/input_field.dart';

class AdminAddArticlePage extends ConsumerStatefulWidget {
  const AdminAddArticlePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminAddArticlePageState();
}

class _AdminAddArticlePageState extends ConsumerState<AdminAddArticlePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add an Article'),
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
                        ? const Text('No image selected.')
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
                  onTap: () async {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      ref.watch(pickImageProvider.state).state = image;
                    }
                  },
                  child: const Text(
                    'Pick an image',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
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
                              _addArticle();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                            ),
                            child: const Text('Add the article'),
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

  void _addArticle() async {
    final firestoreDB = ref.read(databaseProvider);
    final imagePicker = ref.read(pickImageProvider);
    final storage = ref.read(storageProvider);
    final category = ref.read(uiChangesProvider).articleCategory;

    if (firestoreDB == null || storage == null) return;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        category.isEmpty) {
      openIconSnackBar(
        context,
        'Please fill all the fields',
        const Icon(
          Icons.error,
          color: Colors.white,
        ),
      );
      ref.read(uiChangesProvider).isLoading(false);
      return;
    }

    if (imagePicker != null) {
      final url = await storage.uploadImage(imagePicker.path);

      await firestoreDB.addArticle(Article(
        title: titleController.text,
        description: descriptionController.text,
        category: category,
        imageUrl: url,
        timestamp: formattedDate,
      ));
    } else {
      await firestoreDB.addArticle(Article(
        title: titleController.text,
        description: descriptionController.text,
        category: category,
        timestamp: formattedDate,
      ));
    }

    openIconSnackBar(
      context,
      'Added the article',
      const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

    Navigator.pop(context);
  }
}
