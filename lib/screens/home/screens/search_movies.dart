import 'package:flutter/material.dart';
import 'package:movie/config/theme/theme.dart';
import 'package:movie/config/theme/theme_config.dart';
import 'package:movie/screens/movies/bloc/movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchMoviesList extends StatefulWidget {
  SearchMoviesList({Key? key}) : super(key: key);

  @override
  State<SearchMoviesList> createState() => _SearchMoviesListState();
}

class _SearchMoviesListState extends State<SearchMoviesList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(20.0),
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _showSearchFormFeild(),
                const SizedBox(height: 50.0),
                _diplaySearchedMovies(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _diplaySearchedMovies() {
    return BlocBuilder<MoviesBloc, MoviesState>(
      buildWhen: (previous, current) => current is SearchMoviesListLoaded,
      builder: (context, state) {
        if (state is SearchMoviesListLoaded) {
          return _displayListOfMovies(state.moviesList);
        }
        return Container();
      },
    );
  }

  Widget _displayListOfMovies(MoviesList? moviesList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemCount: moviesList?.results?.length ?? 0,
      itemBuilder: (BuildContext ctx, index) {
        return SizedBox(
          child: CachedNetworkImage(
            imageUrl: moviesList?.results?[index].image?.url ?? "",
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }

  Widget _showSearchFormFeild() {
    return TextFormField(
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
        BlocProvider.of<MoviesBloc>(context).add(SearchMoviesByStringEvent(
            dateTime: DateTime.now(), searchString: value));
      }),
    );
  }
}
