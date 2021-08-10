import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:scientia_app/services/load_data.dart';
import 'package:scientia_app/screens/article.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int pageNumber = 0;
  int currentCategory = 0; // default -> home

  List<String?> titles = [];
  List<String?> imgSrcs = [];
  List<String?> articleSrcs = [];

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    pageNumber = 0;
    Map<String, List<String?>>? newItems;

    while (newItems == null) {
      newItems = await LoadData.loadArticlePage(
        pageNumber: pageNumber,
        category: currentCategory
      );
    }

    titles = newItems['titles']!;
    imgSrcs = newItems['imgSrcs']!;
    articleSrcs = newItems['articleSrcs']!;

    if(mounted) setState(() {});

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    pageNumber++;
    Map<String, List<String?>>? newItems;

    while (newItems == null) {
      newItems = await LoadData.loadArticlePage(
        pageNumber: pageNumber,
        category: currentCategory
      );
    }

    titles.addAll(newItems['titles']!);
    imgSrcs.addAll(newItems['imgSrcs']!);
    articleSrcs.addAll(newItems['articleSrcs']!);

    if(mounted) setState(() {});

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // first time loading
    if(titles.isEmpty) {
      var items = ModalRoute.of(context)!.settings.arguments as Map;
      titles.addAll(items['titles']);
      imgSrcs.addAll(items['imgSrcs']);
      articleSrcs.addAll(items['articleSrcs']);
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Image(
                    image: AssetImage('assets/logo-scientia-ns.png'),
                    fit: BoxFit.cover
                ),
              ),
            ],
          ),
          titleSpacing: 5,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        drawer: Container(
          width: 250,
          child: Drawer(
            child: ListView(
              itemExtent: 45.0,
              children:
                // TODO: search bar
                <Widget>[SizedBox(height: 50)] + // search bar placeholder
                List.generate(9, (index) {
                  List<String> tileNames = [
                    "Home", "Știri", "Tehnologie",
                    "Fizică", "Univers", "Biologie",
                    "Humanus", "Bloguri", "Setări"
                  ];
                  List<IconData> tileIcons = [
                    Icons.home, Icons.feed, Icons.build,
                    Icons.science, Icons.auto_awesome, Icons.biotech,
                    Icons.psychology, Icons.people, Icons.settings
                  ];

                  return ListTile(
                    leading: Icon(tileIcons[index]),
                    title: Text(tileNames[index]),
                    selected: currentCategory == index,
                    onTap: () async {
                      if (currentCategory != index) {
                        print("Switching to " + tileNames[index]);

                        pageNumber = 0;
                        currentCategory = index;

                        Map<String, List<String?>>? newItems;

                        while (newItems == null) {
                          newItems = await LoadData.loadArticlePage(
                              pageNumber: pageNumber,
                              category: currentCategory
                          );
                        }

                        titles = newItems['titles']!;
                        imgSrcs = newItems['imgSrcs']!;
                        articleSrcs = newItems['articleSrcs']!;

                        setState(() {});

                        Navigator.pop(context);

                        print("Done!");
                      }
                    },
                  );
                })
            ),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: titles.length,
            cacheExtent: 10000,
            //physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return Article(
                              src: articleSrcs[index]!,
                              title: titles[index]!,
                              img: (imgSrcs[index] != null) ? CachedNetworkImage(
                                imageUrl: imgSrcs[index]!,
                                fit: BoxFit.cover
                              ) : null,
                              index: index
                            );
                          },
                          //transitionDuration: Duration(seconds: 0),
                        )
                      );
                    },
                    child: Column(
                      children: [
                        (imgSrcs[index] != null)
                          ? Hero(
                            tag: "articleImg" + index.toString(),
                            child: CachedNetworkImage(
                              imageUrl: imgSrcs[index]!,
                              fit: BoxFit.cover
                            ),
                          )
                          : SizedBox(height: 1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            titles[index]!,
                            style: TextStyle(
                              color: Color(0xff1f738b),
                              fontFamily: 'Helvetica',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        )
    );
  }
}