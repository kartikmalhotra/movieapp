import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/config/application.dart';
import 'package:movie/shared/models/profile_model.dart';
import 'package:movie/shared/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryImpl repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<GetUserProfile>(
        (event, emit) => _mapGetUserProfileEventToState(event, emit));
  }

  Future<void> _mapGetUserProfileEventToState(event, emit) async {
    emit(const ProfileLoader());
    var response = await repository.fetchUserProfile();
    if (response != null && response is List || response['error'] == null) {
      UserDetails? _userList = UserDetails.fromJson(response);
      Application.userDetails = _userList;
      repository.userDetailsData = _userList;

      /// Store time zone data
      Application.timezoneService!.timezoneStringData = _userList.timezone;

      emit(ProfileLoadedState(userDetails: _userList));
    } else {
      emit(ProfileLoadedState(error: response?['error']));
    }
  }
}
