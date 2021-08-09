import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scientia_app/services/load_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Article extends StatefulWidget {
  final String src;
  final String title;
  final CachedNetworkImage? img;
  final int index;

  const Article({
    Key? key,
    required this.src,
    required this.title,
    required this.img,
    required this.index,
  }) : super(key: key);

  @override
  _ArticleState createState() => _ArticleState(src, title, img, index);
}

class _ArticleState extends State<Article> {
  final String src;
  final String title;
  final CachedNetworkImage? img;
  final int index;

  late String articleDetails;
  String? articleHtml;

  List<YoutubePlayerController> videoControllers = [];

  _ArticleState(this.src, this.title, this.img, this.index);

  void loadArticleText() async {
    List<String?> article =
        await LoadData.loadArticle(src: src, hasImg: (img != null));
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
  void initState() {
    super.initState();

    loadArticleText();
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
    return Scaffold(
      appBar: AppBar(
        // backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
        iconTheme: IconThemeData(color: Colors.black),
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
        titleSpacing: 5,
        backgroundColor: Colors.white,
        elevation: 0,
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
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("loading"),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Helvetica',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
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
                      color: Colors.black54,
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
                                attr["src"] != img!.imageUrl.substring(23) &&
                                attr["src"]!.startsWith("/images"):
                            networkImageRender(
                                mapUrl: (url) => "https://scientia.ro" + url!),
                      },
                      style: {
                        "a": Style(
                          textDecoration: TextDecoration.none,
                        ),
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
