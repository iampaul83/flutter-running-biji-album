import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/biji/biji.dart' as biji;
import 'package:flutter_app/biji/biji.dart';
import 'package:flutter_app/screens/biji_album_list_page.dart';
import 'package:http/http.dart' as http;

class BijiAlbumPage extends StatefulWidget {

  final BijiAlbum album;

  BijiAlbumPage(this.album);

  @override
  State<StatefulWidget> createState() => _BijiAlbumPageState();
}
class _BijiAlbumPageState extends State<BijiAlbumPage> {

  ScrollController _scrollController = new ScrollController();

  List<BijiPhoto> photos = [];
  int nextPage = 0;
  bool loading = false;
  bool isDisposed = false;

  _loadPhotos() async {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });

    final newPhotos = await biji.loadPhotos(widget.album, nextPage);

    if (!isDisposed) {
      setState(() {
        photos.addAll(newPhotos);
        nextPage++;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext pageContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: photos.length + 1,
        itemBuilder: (context, index) {
          // loading item
          if ((index + 1) > photos.length) {
            return _buildProgressIndicator();
          }
          BijiPhoto photo = photos[index];
          return Image.network(photo.getSmallUrl());
        },
      )
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new CircularProgressIndicator()
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadPhotos();
      }
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }


}

