part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoader extends ProfileState {
  const ProfileLoader();

  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final UserDetails? userDetails;
  final String? error;

  const ProfileLoadedState({this.userDetails, this.error});

  @override
  List<Object?> get props => [userDetails, error];
}
