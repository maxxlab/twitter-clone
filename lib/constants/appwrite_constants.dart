class AppWriteConstants {
  static const String databseId = '6572da0b16bce65cc46b';
  static const String projectId = '656ef7809818771d5d72';
  static const String endPoint = 'http://26.54.99.224/v1';

  static const String usersCollectionId = '6572da1f1413d1f435b0';
  static const String tweetsCollectionId = '6576e7ae62469d5609b1';

  static const String imagesBucketId = '6576f23120528d3b4caa';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
}
