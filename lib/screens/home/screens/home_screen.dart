import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie/config/theme/theme.dart';
import 'package:movie/config/theme/theme_config.dart';
import 'package:movie/screens/home/screens/create_playlist.dart';
import 'package:movie/screens/home/screens/search_movies.dart';
import 'package:movie/screens/movies/bloc/movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/shared/bloc/auth/auth_bloc.dart';
import 'package:movie/shared/bloc/playlist/bloc/playlist_bloc.dart';

class HomeScreenDisplay extends StatelessWidget {
  final int currentIndex;

  const HomeScreenDisplay({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreen(currentIndex: currentIndex);
  }
}

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  const HomeScreen({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentIndex;
  String? fcmToken;
  ReceivePort _port = ReceivePort();
  String latestDownloadedPdfFilePath = "";
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    currentIndex = widget.currentIndex;

    super.initState();
    // firebaseNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.yellowAccent,
        actions: [
          Center(
            child: InkWell(
              onTap: () async {
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              child: Text(
                "Logout",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateMovieScreen()));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          color: Colors.black,
          child: _displayBody(),
        ),
      ),
    );
  }

  Widget _displayBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        Container(height: 30),
        _searchTextFormFeild(),
        const SizedBox(height: 30.0),
        _displayListOfPlaylist(),
        _diplayMovies(),
      ],
    );
  }

  Widget _searchTextFormFeild() {
    return TextFormField(
      focusNode: _focusNode,
      onTap: () {
        _focusNode.unfocus();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SearchMoviesList()));
      },
      cursorColor: LightAppColors.appBlueColor,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        hintStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: Colors.grey[900]),
        helperStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        labelText: 'Search Movies',
      ),
      validator: (String? text) {
        if (text?.isEmpty ?? true) {
          return "Enter your password";
        }

        return null;
      },
      onChanged: ((value) {
        BlocProvider.of<MoviesBloc>(context)
            .add(GetMoviesEvent(dateTime: DateTime.now()));
      }),
    );
  }

  Widget _diplayMovies() {
    return BlocBuilder<MoviesBloc, MoviesState>(
      buildWhen: (previous, current) => current is MoviesListLoaded,
      builder: (context, state) {
        if (state is MoviesListLoaded) {
          return _displayListOfMovies(state.moviesList);
        }
        return Container();
      },
    );
  }

  Widget _displayListOfPlaylist() {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      buildWhen: (previous, current) => current is PlaylistListLoaded,
      builder: (context, state) {
        if (state is PlaylistListLoaded &&
            (state.playlistModel?.length ?? 0) != 0) {
          List<Widget> _playListChips = [];
          for (int i = 0; i < (state.playlistModel?.length ?? 0); i++) {
            if (state.playlistModel?[i].title?.isNotEmpty ?? false) {
              _playListChips.add(Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Text(
                    state.playlistModel?[i].title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ));
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Playlists",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Wrap(
                children: <Widget>[
                  ..._playListChips,
                ],
              ),
              const SizedBox(height: 50.0),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _displayListOfMovies(MoviesList? moviesList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Movies",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20.0),
        GridView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: moviesList?.results?.length ?? 0,
            itemBuilder: (BuildContext ctx, index) {
              return SizedBox(
                height: AppScreenConfig.safeBlockVertical! * 40,
                child: CachedNetworkImage(
                  imageUrl: moviesList?.results?[index].image?.url ?? "",
                  fit: BoxFit.fill,
                ),
              );
            }),
      ],
    );
  }
}
