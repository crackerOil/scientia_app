import 'package:flutter/material.dart';
import 'package:scientia_app/services/load_data.dart';

class SearchWidget extends StatefulWidget {
  final String searchQuery;

  const SearchWidget({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _loading = false;

  void loadSearches() async {
    await LoadData.loadSearchQuery(searchQuery: widget.searchQuery);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    loadSearches();
  }

  @override
  Widget build(BuildContext context) {
    return (_loading) ? Center(child: CircularProgressIndicator()) : Container();
  }
}
