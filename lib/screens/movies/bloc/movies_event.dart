part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class GetMoviesEvent extends MoviesEvent {
  final DateTime dateTime;

  const GetMoviesEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class SearchMoviesByStringEvent extends MoviesEvent {
  final String searchString;
  final DateTime dateTime;

  const SearchMoviesByStringEvent({
    required this.searchString,
    required this.dateTime,
  });

  @override
  List<Object> get props => [
        searchString,
        dateTime,
      ];
}

class CreateMoviesInitialize extends MoviesEvent {
  const CreateMoviesInitialize();

  @override
  List<Object> get props => [];
}

class GetPublishedMovies extends MoviesEvent {
  final int page;
  final DateTime dateTime;
  final bool? isRefresh;

  const GetPublishedMovies({
    required this.page,
    required this.dateTime,
    this.isRefresh,
  });

  @override
  List<Object?> get props => [page, dateTime, isRefresh];
}

class CreatePlaylistEvent extends MoviesEvent {
  final String title;
  final String description;
  final String type;
  final Map<String, dynamic> data;
  final DateTime dateTime;

  const CreatePlaylistEvent({
    required this.title,
    required this.description,
    required this.type,
    required this.data,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [title, description, type, data, dateTime];
}
