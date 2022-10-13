import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:movie/screens/movies/repository/movies_repository.dart';
import 'package:movie/shared/bloc/playlist/model/playlist_model.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepositoryImpl repository;

  Map<String, dynamic> payementLimit = {};

  MoviesBloc({
    required this.repository,
  }) : super(MoviesInitial(dateTime: DateTime.now())) {
    on<CreateMoviesInitialize>(
        (event, emit) => emit(MoviesInitial(dateTime: DateTime.now())));
    on<GetMoviesEvent>((event, emit) => _mapGetMoviesEvent(event, emit));

    on<SearchMoviesByStringEvent>(
        (event, emit) => _mapSearchMoviesByStringEvent(event, emit));
    on<CreatePlaylistEvent>(
        (event, emit) => _mapCreatePlaylistEvent(event, emit));
  }

  Future<void> _mapGetMoviesEvent(
      MoviesEvent event, Emitter<MoviesState> emit) async {
    emit(MoviesLoader(dateTime: DateTime.now()));
    var response = await repository.getMoviesList();
    if (response != null) {
      MoviesList moviesListModel = MoviesList.fromJson(json.decode(response));
      emit(MoviesListLoaded(
          moviesList: moviesListModel, dateTime: DateTime.now()));
    } else {
      emit(MoviesListLoaded(
          error: "Something went Wrong", dateTime: DateTime.now()));
    }
  }

  Future<void> _mapSearchMoviesByStringEvent(
      SearchMoviesByStringEvent event, Emitter<MoviesState> emit) async {
    emit(MoviesLoader(dateTime: DateTime.now()));
    final response = await repository.getMoviesBySearch(event.searchString);
    if (response != null) {
      MoviesList searchMoviesList = MoviesList.fromJson(json.decode(response));
      emit(SearchMoviesListLoaded(
          moviesList: searchMoviesList, dateTime: DateTime.now()));
    } else {
      emit(SearchMoviesListLoaded(
          error: "Something went Wrong", dateTime: DateTime.now()));
    }
  }

  Future<void> _mapCreatePlaylistEvent(
      CreatePlaylistEvent event, Emitter<MoviesState> emit) async {
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
