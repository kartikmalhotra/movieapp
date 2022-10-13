part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
}

class CreatePlaylistLoader extends MoviesState {
  final DateTime dateTime;

  const CreatePlaylistLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class MoviesLoader extends MoviesState {
  final DateTime dateTime;

  const MoviesLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class PlaylistLoader extends MoviesState {
  final DateTime dateTime;

  const PlaylistLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class StopMoviesLoader extends MoviesState {
  final DateTime dateTime;

  const StopMoviesLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class MoviesByIdLoader extends MoviesState {
  const MoviesByIdLoader();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {
  final DateTime? dateTime;

  const MoviesInitial({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class MoviesListLoaded extends MoviesState {
  final DateTime dateTime;
  final MoviesList? moviesList;
  final String? error;

  const MoviesListLoaded({
    required this.dateTime,
    this.moviesList,
    this.error,
  });

  @override
  List<Object?> get props => [dateTime, moviesList, error];
}

class SearchMoviesListLoaded extends MoviesState {
  final DateTime dateTime;
  final MoviesList? moviesList;
  final String? error;

  const SearchMoviesListLoaded({
    required this.dateTime,
    this.moviesList,
    this.error,
  });

  @override
  List<Object?> get props => [dateTime, moviesList, error];
}

class ScheduledMoviesLoader extends MoviesState {
  const ScheduledMoviesLoader();

  @override
  List<Object> get props => [];
}
