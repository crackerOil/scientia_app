import 'package:flutter/material.dart';
import 'package:scientia_app/services/load_data.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void loadData() async {
    Map<String, List<String?>>? data;

    while (data == null) {
      data = await LoadData.loadArticlePage(pageNumber: 0, category: 0);
    }

    Navigator.pushReplacementNamed(context, '/home', arguments: data);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("loading"),
          ],
        ),
      ),
    );
  }
}
