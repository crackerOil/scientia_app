import 'package:flutter/material.dart';
import 'package:scientia_app/widgets/home_widget.dart';
import 'package:scientia_app/widgets/inherited_data_widget.dart';
import 'package:scientia_app/widgets/search_widget.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  int _currentCategory = 0; // default -> home
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                const SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    itemExtent: 45.0,
                    children:
                      // TODO: search bar
                      <Widget>[
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Caută...'
                          ),
                          onSubmitted: (input) {
                            if (input.isNotEmpty) {
                              print("Searching for '$input'...");

                              setState(() {
                                _currentCategory = -1;
                                _searchQuery = input;
                              });

                              _searchController.clear();

                              Navigator.pop(context);
                            }
                          }
                        ),
                      ]
                      ..addAll(List<Widget>.generate(9, (index) {
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
                          selected: _currentCategory == index,
                          onTap: () async {
                            if (_currentCategory != index) {
                              print("Switching to ${tileNames[index]}");

                              setState(() {
                                _currentCategory = index;
                                _searchQuery = "";
                              });

                              Navigator.pop(context);

                              print("Done!");
                            }
                          },
                        );
                      }))
                  ),
                ),
              ],
            ),
          ),
        ),
        body: InheritedDataWidget(
          data: (_searchQuery.isEmpty) ? _currentCategory : _searchQuery,
          child: (_searchQuery.isEmpty) ? HomeWidget() : SearchWidget()
        )
    );
  }
}