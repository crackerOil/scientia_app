import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class LoadData {
  static Future<Map<String, List<String?>>> loadArticlePage(
      {required int pageNumber}) async {
    // TODO: add category functionality

    http.Response response = await http.get(Uri.parse(
        "https://scientia.ro/?start=${pageNumber * 28}&type=rss&format=feed"));

    RssFeed feed = RssFeed.parse(response.body);

    List<RssItem>? items = feed.items;

    List<String?> titles = items!.map((item) => item.title).toList();

    // match <img> src attribute in description
    RegExp imgMatcher = RegExp("src=\"(.*?)\"", caseSensitive: false);
    List<String?> imgSrcs = items.map((item) => item.description).toList();
    imgSrcs = imgSrcs.map((src) {
      var match = imgMatcher.firstMatch(src!);
      return (match != null) ? match.group(1).toString() : null;
    }).toList();

    List<String?> articleSrcs = items.map((item) => item.link).toList();

    return {'titles': titles, 'imgSrcs': imgSrcs, 'articleSrcs': articleSrcs};
  }

  static Future<List<String?>> loadArticle(
      {required String src, required bool hasImg}) async {
    http.Response response = await http.get(Uri.parse(src));

    dom.Document document = parse(response.body);

    dom.Element articleBody = document
        .getElementsByClassName("item-page")[0]
        .children
        .firstWhere(
            (element) => element.attributes["itemprop"] == "articleBody");

    // print(articleBody.innerHtml);

    dom.Element? author;
    try {
      author = document.getElementsByClassName("createdby")[0];
    } on RangeError {
      author = null;
    }

    dom.Element? category;
    try {
      category = document.getElementsByClassName("category-name")[0];
    } on RangeError {
      category = null;
    }

    return [
      author != null ? author.innerHtml : null,
      category != null ? category.innerHtml : null,
      articleBody.innerHtml
    ];
  }
}
