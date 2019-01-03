import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/biji/biji.dart' as biji;
import 'package:flutter_app/biji/biji.dart';
import 'package:flutter_app/screens/biji_album_page.dart';

class BijiAlbumListPage extends StatelessWidget {
  final BijiEvent bijiEvent;
  final Future<List<BijiAlbum>> albumList;

  BijiAlbumListPage._(this.bijiEvent, this.albumList);

  factory BijiAlbumListPage(BijiEvent bijiEvent) {
    return BijiAlbumListPage._(bijiEvent, biji.searchAlbums(bijiEvent.id));
  }

  @override
  Widget build(BuildContext pageContext) {

    return Scaffold(
      appBar: AppBar(
        title: Text(bijiEvent.name),
      ),
      body: Center(
        child: FutureBuilder<List<BijiAlbum>>(
          future: albumList,
          builder: (context, snapshot) {
            // By default, show a loading spinner
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        pageContext,
                        MaterialPageRoute(
                          builder: (context) => BijiAlbumPage(snapshot.data[index])
                        )
                      );
                    },
                    child: Text(snapshot.data[index].name),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

          },
        ),
      ),
    );
  }
}

