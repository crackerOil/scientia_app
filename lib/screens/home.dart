import 'package:flutter/material.dart';
import 'package:scientia_app/widgets/home_widget.dart';
import 'package:scientia_app/widgets/inherited_data_widget.dart';
import 'package:scientia_app/widgets/search_widget.dart';

import '../scientia_app.dart';

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
              const SizedBox(width: 80),
              Flexible(
                child: Image(
                    image: (ScientiaApp.of(context)!.themeMode == ThemeMode.dark)
                        ? AssetImage('assets/logo-scientia-dark.png')
                        : AssetImage('assets/logo-scientia.png'),
                    fit: BoxFit.cover
                ),
              ),
            ],
          ),
        ),
        drawer: Container(
          width: 200,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color(0xff07313b),
            ),
            child: Drawer(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      itemExtent: 45.0,
                      children:
                        <Widget>[
                          TextField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              hintText: 'Caută...',
                              hintStyle: TextStyle(color: Colors.white60)
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
                            leading: Icon(
                              tileIcons[index],
                              color: (_currentCategory != index) ? Colors.white : null
                            ),
                            title: Text(
                              tileNames[index],
                              style: (_currentCategory != index) ? TextStyle(color: Colors.white) : null
                            ),
                            selected: _currentCategory == index,
                            onTap: () async {
                              if (_currentCategory != index) {
                                Navigator.pop(context);

                                if (index != 8) {
                                  print("Switching to '${tileNames[index]}'");

                                  setState(() {
                                    _currentCategory = index;
                                    _searchQuery = "";
                                  });

                                  print("Done!");
                                } else {
                                  Navigator.pushNamed(context, '/settings');
                                }
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
        ),
        body: InheritedDataWidget(
          data: (_searchQuery.isEmpty) ? _currentCategory : _searchQuery,
          child: (_searchQuery.isEmpty) ? HomeWidget() : SearchWidget()
        )
    );
  }
}