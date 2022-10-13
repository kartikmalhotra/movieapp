part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();
}

class CreatePlaylistLoader extends PlaylistState {
  final DateTime dateTime;

  const CreatePlaylistLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class PlaylistInitial extends PlaylistState {
  final DateTime? dateTime;

  const PlaylistInitial({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class PlaylistLoader extends PlaylistState {
  final DateTime dateTime;

  const PlaylistLoader({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class PlaylistByIdLoader extends PlaylistState {
  const PlaylistByIdLoader();

  @override
  List<Object> get props => [];
}

class PlaylistListLoaded extends PlaylistState {
  final DateTime dateTime;
  final List<PlaylistModel>? playlistModel;
  final String? error;

  const PlaylistListLoaded({
    required this.dateTime,
    this.playlistModel,
    this.error,
  });

  @override
  List<Object?> get props => [dateTime, playlistModel, error];
}

class SearchPlaylistListLoaded extends PlaylistState {
  final DateTime dateTime;
  final MoviesList? moviesList;
  final String? error;

  const SearchPlaylistListLoaded({
    required this.dateTime,
    this.moviesList,
    this.error,
  });

  @override
  List<Object?> get props => [dateTime, moviesList, error];
}
