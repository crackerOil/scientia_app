import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class LoadData {
  static Future<Map<String, List<String?>>?> loadArticlePage({
    required int pageNumber,
    required int category
  }) async {
    String pageUrl = "https://scientia.ro/";

    List<String> categoryUrls = [
      "", "stiri-stiinta.html", "tehnologie.html",
      "fizica.html", "univers.html", "biologie.html",
      "homo-humanus.html", "blogurile-scientia.html"
    ];
    List<int> categoryPageLengths = [28, 15, 20, 20, 20, 20, 20, 25];

    pageUrl += categoryUrls[category];
    pageUrl += "/?start=${pageNumber * categoryPageLengths[category]}";
    pageUrl += "&type=rss&format=feed";

    http.Response response;
    try {
      response = await http.get(Uri.parse(pageUrl));
    } catch (e) {
      print(e);
      return null;
    }

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

  static Future<List<String?>?> loadArticle({
    required String src,
    required bool hasImg
  }) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(src));
    } catch (e) {
      print(e);
      return null;
    }

    dom.Document document = parse(response.body);

    dom.Element articleBody = document
        .getElementsByClassName("item-page")[0]
        .children
        .firstWhere(
            (element) => element.attributes["itemprop"] == "articleBody");

    // print(articleBody.children);

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

  static Future<Map<String, List<String?>>?> loadSearchQuery({
    required String searchQuery
  }) async {
    String searchUrl = "https://scientia.ro/component/finder/search.feed?t[0]=18&q=$searchQuery&type=rss";

    http.Response response;
    try {
      response = await http.get(Uri.parse(searchUrl));
    } catch (e) {
      print(e);
      return null;
    }

    RssFeed searchFeed = RssFeed.parse(response.body);

    List<RssItem>? searchItems = searchFeed.items;

    if (searchItems!.isEmpty) {
      return null;
    }

    List<String?> titles = searchItems.map((item) => item.title).toList();
    List<String?> articleSrcs = searchItems.map((item) => item.link).toList();

    return {"titles": titles, "articleSrcs": articleSrcs};
  }
}
