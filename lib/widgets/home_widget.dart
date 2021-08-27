import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scientia_app/services/load_data.dart';
import 'package:scientia_app/services/notification_manager.dart';
import 'package:scientia_app/widgets/inherited_data_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  int _pageNumber = 0;
  int _currentCategory = 0;

  bool _loading = false;

  List<String?> _titles = [];
  List<String?> _imgSrcs = [];
  List<String?> _articleSrcs = [];

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void reloadData() async {
    _pageNumber = 0;
    Map<String, List<String?>>? newItems;

    while (newItems == null) {
      newItems = await LoadData.loadArticlePage(
          pageNumber: _pageNumber,
          category: _currentCategory
      );
    }

    _titles = newItems['titles']!;
    _imgSrcs = newItems['imgSrcs']!;
    _articleSrcs = newItems['articleSrcs']!;

    if(mounted) setState(() { _loading = false; });
  }

  void _onRefresh() {
    reloadData();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageNumber++;
    Map<String, List<String?>>? newItems;

    while (newItems == null) {
      newItems = await LoadData.loadArticlePage(
          pageNumber: _pageNumber,
          category: _currentCategory
      );
    }

    _titles.addAll(newItems['titles']!);
    _imgSrcs.addAll(newItems['imgSrcs']!);
    _articleSrcs.addAll(newItems['articleSrcs']!);

    if(mounted) setState(() {});

    _refreshController.loadComplete();
  }

  void goToArticle(BuildContext context, int index) {
    Navigator.pushNamed(context, '/article', arguments: {
      'src': _articleSrcs[index]!,
      'title': _titles[index]!,
      'img': (() {
        if (_imgSrcs[index] == null) {
          return null;
        } else if (_imgSrcs[index]!.contains("youtube")) {
          return CachedNetworkImage(
              imageUrl: "https://img.youtube.com/vi/${YoutubePlayer
                  .convertUrlToId(
                  _imgSrcs[index]!)!}/hqdefault.jpg",
              fit: BoxFit.cover
          );
        } else {
          return CachedNetworkImage(
              imageUrl: _imgSrcs[index]!,
              fit: BoxFit.cover
          );
        }
      })(),
      'index': index
    });
  }

  @override
  Widget build(BuildContext context) {
    final InheritedDataWidget? inheritedWidget = InheritedDataWidget.of(context);

    if (_titles.isEmpty || _currentCategory != inheritedWidget!.data) {
      _currentCategory = inheritedWidget!.data;

      _loading = true;
      reloadData();
    }

    // navigate to new article if opened from notification
    if (NotificationManager().openedFromNotification && !_loading) {
      NotificationManager().openedFromNotification = false;

      Future.delayed(Duration(milliseconds: 500));
      Future.microtask(() => goToArticle(context, 0));
    }

    return (_loading) ? Center(child: CircularProgressIndicator()) : SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
          itemCount: _titles.length,
          cacheExtent: 10000,
          //physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                child: InkWell(
                  onTap: () => goToArticle(context, index),
                  child: Column(
                    children: [
                      (_imgSrcs[index] != null) ? Hero(
                        tag: "articleImg" + index.toString(),
                        child: (() {
                          if (_imgSrcs[index]!.contains("youtube")) {
                            return CachedNetworkImage(
                                imageUrl: "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(_imgSrcs[index]!)!}/hqdefault.jpg",
                                fit: BoxFit.cover
                            );
                          } else {
                            return CachedNetworkImage(
                                imageUrl: _imgSrcs[index]!,
                                fit: BoxFit.cover
                            );
                          }
                        })()
                      ) : SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                            _titles[index]!,
                            style: Theme.of(context).textTheme.headline6
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
