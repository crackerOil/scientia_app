import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scientia_app/services/load_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  late final String src;
  late final String title;
  late final CachedNetworkImage? img;
  late final int index;

  late String articleDetails;
  String? articleHtml;

  List<YoutubePlayerController> videoControllers = [];

  void loadArticleText() async {
    List<String?>? article;

    while (article == null) {
      article = await LoadData.loadArticle(
          src: src,
          hasImg: (img != null)
      );
    }

    String? author = article[0];
    String? category = article[1];
    articleHtml = article[2];

    // handle details in case author or category are left null
    articleDetails =
        "<div>${author ?? ''}<br />${category ?? ''}</div>";

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (videoControllers.isNotEmpty) {
      videoControllers.forEach((controller) {
        controller.dispose();
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (articleHtml == null) {
      Map initialParams = ModalRoute.of(context)!.settings.arguments as Map;
      src = initialParams['src'];
      title = initialParams['title'];
      img = initialParams['img'];
      index = initialParams['index'];

      loadArticleText();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Image(
                  image: AssetImage('assets/logo-scientia-ns.png'),
                  fit: BoxFit.cover),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          (img != null)
              ? Hero(
                  tag: "articleImg" + index.toString(),
                  child: img!,
                )
              : SizedBox(height: 1),
          (articleHtml == null)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headline6
                        ),
                      ),
                      Html(data: articleDetails, style: {
                        "div": Style(
                          color: Colors.grey[700],
                        ),
                        "a": Style(
                          textDecoration: TextDecoration.none,
                        )
                      }),
                      Divider(
                        height: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      // TODO: make links work
                      // TODO: improve videos (later)
                      Html(
                        data: articleHtml,
                        customRender: {
                          "iframe": (context, child) {
                            YoutubePlayerController _controller = YoutubePlayerController(
                                initialVideoId: YoutubePlayer.convertUrlToId(
                                    context.tree.element!.attributes["src"]!
                                )!,
                                flags: YoutubePlayerFlags(
                                  autoPlay: false,
                                  hideThumbnail: true,
                                )
                            );
                            videoControllers.add(_controller);

                            return YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              bottomActions: <Widget>[
                                const SizedBox(width: 10),
                                CurrentPosition(),
                                const SizedBox(width: 10),
                                ProgressBar(isExpanded: true),
                                const SizedBox(width: 10),
                                RemainingDuration(),
                                const SizedBox(width: 10)
                              ],
                            );
                          }
                        },
                        customImageRenders: {
                          // prefix relative paths with base url
                          (attr, _) =>
                            attr["src"] != null &&
                            attr["src"] != img?.imageUrl.substring(23) &&
                            attr["src"]!.startsWith("/images"):
                              networkImageRender(
                                  mapUrl: (url) => "https://scientia.ro" + url!
                              ),
                        },
                        style: {
                          "a": Style(
                            textDecoration: TextDecoration.none,
                          ),
                        },
                      ),
                    ],
                  ),
              ),
        ],
      ),
    );
  }
}
