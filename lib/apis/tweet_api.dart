import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final tweetDoc = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(tweetDoc);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        queries: [Query.orderDesc('tweetedAt')]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollectionId}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final tweetDoc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );
      return right(tweetDoc);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final tweetDoc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );
      return right(tweetDoc);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return documents.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: id);
  }
}
