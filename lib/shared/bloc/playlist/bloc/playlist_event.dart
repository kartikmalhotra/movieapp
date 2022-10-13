part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();
}

class GetPlaylistEvent extends PlaylistEvent {
  final DateTime dateTime;

  const GetPlaylistEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CreatePlaylistInitialize extends PlaylistEvent {
  const CreatePlaylistInitialize();

  @override
  List<Object> get props => [];
}

class SearchPlaylistByStringEvent extends PlaylistEvent {
  final String searchString;
  final DateTime dateTime;

  const SearchPlaylistByStringEvent({
    required this.searchString,
    required this.dateTime,
  });

  @override
  List<Object> get props => [
        searchString,
        dateTime,
      ];
}

class GetPublishedMovies extends PlaylistEvent {
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

class CreatePlaylistEvent extends PlaylistEvent {
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
