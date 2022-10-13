import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:movie/shared/bloc/playlist/model/playlist_model.dart';
import 'package:movie/utils/utils.dart';

abstract class PlaylistRepository {
  List<PlaylistModel>? get playlist;
  set playlist(List<PlaylistModel>? post);
}

class PlaylistRepositoryImpl extends PlaylistRepository {
  List<PlaylistModel>? _playlistModel;

  @override
  List<PlaylistModel>? get playlist => _playlistModel;

  @override
  set playlist(List<PlaylistModel>? post) {
    _playlistModel = post;
  }
}
