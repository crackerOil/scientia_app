import 'package:flutter/material.dart';
import 'package:scientia_app/services/load_data.dart';

import 'inherited_data_widget.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String _searchQuery = "";

  bool _loading = false;

  List<String?> _titles = [];
  List<String?> _articleSrcs = [];

  bool _noResults = false;

  void loadSearches() async {
    Map<String, List<String?>>? searchItems;

    searchItems = await LoadData.loadSearchQuery(
        searchQuery: _searchQuery,
    );

    if (searchItems != null) {
      _titles = searchItems['titles']!;
      _articleSrcs = searchItems['articleSrcs']!;
    } else {
      _noResults = true;
    }

    if (mounted) setState(() { _loading = false; });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final InheritedDataWidget? inheritedWidget = InheritedDataWidget.of(context);

    if (_searchQuery != inheritedWidget!.data) {
      _searchQuery = inheritedWidget.data;

      _loading = true;
      loadSearches();
    }

    return (_loading) ? Center(child: CircularProgressIndicator()) : () {
      if (_noResults) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Nu am putut găsi rezultate",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Rezultate pentru \"$_searchQuery\"",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            // Divider(thickness: 1, indent: 10, endIndent: 200),
            SizedBox(height: 20),
            Flexible(
              child: ListView.separated(
                itemCount: _titles.length,
                separatorBuilder: (context, index) {
                  return Divider(indent: 10, endIndent: 10);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          _titles[index]!,
                          style: TextStyle(
                            color: Color(0xff1f738b),
                            fontFamily: 'Helvetica',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/article', arguments: {
                        'src': _articleSrcs[index]!,
                        'title': _titles[index]!,
                        'img': null,
                        'index': index
                      });
                    },
                  );
                }
              ),
            ),
          ],
        );
      }
    }();
  }
}
