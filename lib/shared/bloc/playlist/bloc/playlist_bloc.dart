import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:movie/screens/movies/repository/movies_repository.dart';
import 'package:movie/shared/bloc/playlist/model/playlist_model.dart';
import 'package:movie/shared/bloc/playlist/repository/playlist_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepositoryImpl repository;

  Map<String, dynamic> payementLimit = {};

  PlaylistBloc({
    required this.repository,
  }) : super(PlaylistInitial(dateTime: DateTime.now())) {
    on<CreatePlaylistInitialize>(
        (event, emit) => emit(PlaylistInitial(dateTime: DateTime.now())));
    on<GetPlaylistEvent>((event, emit) => _mapGetPlaylistEvent(event, emit));
  }

  // Future<void> _mapGetPlaylistEvent(
  //     PlaylistEvent event, Emitter<MoviesState> emit) async {
  //   emit(PlaylistLoader(dateTime: DateTime.now()));
  //   var response = await repository.getMoviesList();
  //   if (response != null) {
  //     MoviesList moviesListModel = MoviesList.fromJson(json.decode(response));
  //     emit(PlaylistListLoaded(
  //         moviesList: moviesListModel, dateTime: DateTime.now()));
  //   } else {
  //     emit(PlaylistListLoaded(
  //         error: "Something went Wrong", dateTime: DateTime.now()));
  //   }
  // }

  Future<void> _mapGetPlaylistEvent(
      GetPlaylistEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoader(dateTime: DateTime.now()));
    var response =
        await FirebaseFirestore.instance.collection("user_playlist").get();
    List<PlaylistModel> playlistList = [];
    for (int i = 0; i < response.docs.length; i++) {
      PlaylistModel playlistModel =
          PlaylistModel.fromJson(response.docs[i].data());
      playlistList.add(playlistModel);
    }
    repository.playlist = playlistList;
    emit(PlaylistListLoaded(
        playlistModel: repository.playlist, dateTime: DateTime.now()));
  }

  Future<void> _mapCreatePlaylistEvent(
      CreatePlaylistEvent event, Emitter<PlaylistState> emit) async {
    emit(CreatePlaylistLoader(dateTime: DateTime.now()));
    try {
      var response =
          await FirebaseFirestore.instance.collection("user_playlist").add({
        "title": event.title,
        "description": event.description,
        "type": event.type,
        "movies_list": {}
      });

      print(response);
    } catch (exe) {
      print(exe);
    }
    // if (response != null) {
    //   MoviesList searchMoviesList = MoviesList.fromJson(json.decode(response));
    //   emit(SearchMoviesListLoaded(
    //       moviesList: searchMoviesList, dateTime: DateTime.now()));
    // } else {
    //   emit(SearchMoviesListLoaded(
    //       error: "Something went Wrong", dateTime: DateTime.now()));
    // }
  }
}
