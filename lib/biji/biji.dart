import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:convert';

export 'model.dart';

Future<List<BijiEvent>> searchEvents([String query]) async {
  final uri = _buildUri(queryParameters: {
    'q': 'competition',
    'act': 'list_item',
    'keyword': query
  });
  final response = await http.get(uri);

  return await compute(_mapBijiEventList, response.body);
}

List<BijiEvent> _mapBijiEventList(String html) {
  final document = parse(html);
  final $competitionListRow = document
      .getElementsByClassName("competition-list-row")
      .sublist(1);

  List<BijiEvent> competitionNameList = $competitionListRow.map((e) {
    final $date = e.getElementsByClassName('competition-date').first;
    final $name = e.getElementsByClassName('competition-name').first;
    final $collect = e.getElementsByClassName('competition-collect').first;

    final hasAlbum = e.querySelector('.competition-note .fa.fa-book') != null;

    return BijiEvent(
      id: $collect.attributes['data-id'],
      name: $name.text.trim(),
      year: e.attributes['data-year'],
      date: $date.text.trim(),
      hasAlbum: hasAlbum,
    );
  }).toList();

  return competitionNameList;
}


Future<List<BijiAlbum>> searchAlbums(String id) async {
  final uri = _buildUri(queryParameters: {
    'q': 'album',
    'act': 'gallery_album',
    'competition_id': id
  });
  final response = await http.get(uri);

  return await compute(_mapBijiAlbums, _MapAlbumsData(id, response.body));
}

class _MapAlbumsData {
  final String id;
  final String html;
  _MapAlbumsData(this.id, this.html);
}

List<BijiAlbum> _mapBijiAlbums(_MapAlbumsData data) {
  final document = parse(data.html);
  final $albumTableItem = document
      .querySelectorAll('.gallery-time-section .table-item')
      .sublist(1);

  List<BijiAlbum> albumList = $albumTableItem.map((e) {
    final $itemLeft = e.getElementsByClassName('item-left').first;
    final $a = $itemLeft.getElementsByTagName('a').first;
    final $albumInfo = $itemLeft.getElementsByClassName('album-info').first;

    final albumUri = Uri.parse($a.attributes['href']);

    return BijiAlbum(
        id: data.id,
        albumId: albumUri.queryParameters['album_id'],
        name: $a.text.trim(),
        photoCount: $albumInfo.text.trim()
    );
  }).toList();

  return albumList;
}


Future<List<BijiPhoto>> loadPhotos(BijiAlbum album, int page) async {
  final rowsPerPage = 100;
  final uri = _buildUri(queryParameters: {
    'pop': 'ajax',
    'func': 'album',
    'fename': 'load_more_photos_in_listing_computer'
  });
  final response = await http.post(uri, body: {
    'type': 'album',
    'rows': '${page * rowsPerPage}',
    'need_rows': '$rowsPerPage',
    'cid': album.id,
    'album_id': album.albumId,
  });

  return await compute(_mapBijiPhotos, response.body);
}

List<BijiPhoto> _mapBijiPhotos(String html) {
  final document = parse(html);
  final $images = document.querySelectorAll('.photo-item > a > img');

  List<BijiPhoto> photoList = $images
    .map((e) => BijiPhoto.fromUrl(e.attributes['src']))
    .toList();

  return photoList;
}


Uri _buildUri({path: '/', Map<String, String> queryParameters}) {
  return Uri.https('running.biji.co', path, queryParameters);
}
