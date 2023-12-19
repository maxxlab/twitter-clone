import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
      builder: (context) => TwitterReplyScreen(
            tweet: tweet,
          ));
  final Tweet tweet;
  final replyTextController = TextEditingController();

  TwitterReplyScreen({super.key, required this.tweet});

  void clearReplyField() {
    replyTextController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          final latestTweet = Tweet.fromMap(data.payload);

                          bool isTweetAlreadyPresent = false;
                          for (final tweetModel in tweets) {
                            if (tweetModel.id == latestTweet.id) {
                              isTweetAlreadyPresent = true;
                              break;
                            }
                          }

                          if (!isTweetAlreadyPresent &&
                              latestTweet.repliedTo == tweet.id) {
                            const isNewTweetCreated =
                                'databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.create';
                            const isTweetUpdated =
                                'databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.update';
                            if (data.events.contains(
                              isNewTweetCreated,
                            )) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            } else if (data.events.contains(
                              isTweetUpdated,
                            )) {
                              final stratingPoint =
                                  data.events.first.lastIndexOf('documents.');
                              final endingPoint =
                                  data.events.first.lastIndexOf('.update');
                              final tweetId = data.events.first
                                  .substring(stratingPoint + 10, endingPoint);

                              var tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;

                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere(
                                  (element) => element.id == tweetId);

                              tweet = Tweet.fromMap(data.payload);
                              tweets.insert(tweetIndex, tweet);
                            }
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                        error: (error, st) =>
                            ErrorText(error: error.toString()),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )
        ],
      ),
      bottomNavigationBar: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10),
        child: TextField(
          controller: replyTextController,
          onSubmitted: (value) {
            ref.read(tweetControllerProvider.notifier).shareTweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweet.id,
            );
            clearReplyField();
          },

          decoration: const InputDecoration(hintText: 'Tweet your reply'),
        ),
      ),
    );
  }
}
