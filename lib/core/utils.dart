import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@').first;
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(
        File(
          image.path,
        ),
      );
    }
  }
  return images;
}

String getLinkFromText(String text) {
  String link = '';
  List<String> wordsInSentence = text.split(' ');
  for (String word in wordsInSentence) {
    if (word.startsWith('https://') || word.startsWith('www.')) {
      link = word;
    }
  }
  return link;
}

List<String> getHashtagsFromText(String text) {
  List<String> hashtags = [];
  List<String> wordsInSentence = text.split(' ');
  for (String word in wordsInSentence) {
    if (word.startsWith('#')) {
      hashtags.add(word);
    }
  }
  return hashtags;
}
