import 'package:meta/meta.dart';

class BijiEvent {
  final String id;
  final String name;
  // yyyy
  final String year;
  // 11-14 (三)
  final String date;
  final bool hasAlbum;

  BijiEvent({
    @required this.id,
    @required this.name,
    @required this.year,
    @required this.date,
    @required this.hasAlbum
  });

  @override
  String toString() {
    return name;
  }
}

class BijiAlbum {
  final String id;
  final String albumId;
  final String name;
  final String photoCount;

  BijiAlbum({
    @required this.id,
    @required this.albumId,
    @required this.name,
    @required this.photoCount
  });

  @override
  String toString() {
    return name;
  }
}

//https://cdntwrunning.biji.co/2048_6296B726-1B9D-F23F-7641-091ED07317B7.jpg
//https://cdntwrunning.biji.co/600_6296B726-1B9D-F23F-7641-091ED07317B7.jpg

final _extractPhotoIdRegex = RegExp(r'https://cdntwrunning\.biji\.co\/600_(.*)\.([^.]+)$');

class BijiPhoto {
  final String id;
  final String extenson;

  BijiPhoto(this.id, this.extenson);

  factory BijiPhoto.fromUrl(String url) {
    final match = _extractPhotoIdRegex.firstMatch(url);
    
    return BijiPhoto(match.group(1), match.group(2));
  }

  getSmallUrl() => 'https://cdntwrunning.biji.co/600_$id.$extenson';
  getLargeUrl() => 'https://cdntwrunning.biji.co/2048_$id.$extenson';
}