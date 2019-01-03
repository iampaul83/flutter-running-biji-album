import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/biji/biji.dart' as biji;
import 'package:flutter_app/biji/biji.dart';
import 'package:flutter_app/screens/biji_album_list_page.dart';

class BijiListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BijiListPageState();
}
class _BijiListPageState extends State<BijiListPage> {

  final searchController = TextEditingController();
  Future<List<BijiEvent>> bijiList;
  String q = '';

  @override
  Widget build(BuildContext pageContext) {
    if (bijiList == null) {
      _search('');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Biji List"),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onSubmitted: _search,
          ),
          Flexible(
            child: Center(
              child: FutureBuilder<List<BijiEvent>>(
                future: bijiList,
                builder: (context, snapshot) {
                  // By default, show a loading spinner
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    List<BijiEvent> events = snapshot.data;
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        BijiEvent event = events[index];
                        VoidCallback onPressed;
                        if (event.hasAlbum) {
                          onPressed = () {
                            Navigator.push(
                              pageContext,
                              MaterialPageRoute(
                                builder: (context) => BijiAlbumListPage(event)
                              )
                            );
                          };
                        }
                        return FlatButton(
                          onPressed: onPressed,
                          child: Text(event.name),

                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _search(String query) {
    setState(() {
      bijiList = biji.searchEvents(query);
    });
  }

}

