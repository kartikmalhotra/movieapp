import 'package:flutter/material.dart';
import 'package:movie/config/theme/theme.dart';
import 'package:movie/config/theme/theme_config.dart';
import 'package:movie/screens/movies/bloc/movies_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:movie/shared/bloc/playlist/bloc/playlist_bloc.dart';
import 'package:movie/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CreateMovieScreen extends StatefulWidget {
  const CreateMovieScreen({Key? key}) : super(key: key);

  @override
  State<CreateMovieScreen> createState() => _CreateMovieScreenState();
}

class _CreateMovieScreenState extends State<CreateMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String dropDownValue = "Private";
  List<String> _selectedMoviesList = [];

  MoviesList? moviesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.yellowAccent,
        title: Text(
          "Create",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          color: Colors.black,
          child: SingleChildScrollView(
            child: _displayBody(context),
          ),
        ),
      ),
    );
  }

  Widget _displayBody(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _enterPlaylistTitle(),
          const SizedBox(height: 20.0),
          _enterPlaylistDescription(),
          const SizedBox(height: 20.0),
          _selectPublicPrivateDropdown(),
          const SizedBox(height: 20.0),
          _diplayMovies(),
          const SizedBox(height: 50.0),
          _createPlaylistButton(context),
        ],
      ),
    );
  }

  Widget _diplayMovies() {
    return BlocBuilder<MoviesBloc, MoviesState>(
      buildWhen: (previous, current) => current is MoviesListLoaded,
      builder: (context, state) {
        if (state is MoviesListLoaded) {
          moviesList = state.moviesList;
          return _displayListOfMovies(state.moviesList);
        }
        return Container();
      },
    );
  }

  Widget _displayListOfMovies(MoviesList? moviesList) {
    return Container(
      height: 200,
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1.0,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: moviesList?.results?.length ?? 0,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: () {
              if (moviesList?.results?[index].id != null) {
                _selectedMoviesList.add(moviesList!.results![index].id!);
              } else {
                _selectedMoviesList.remove(moviesList!.results![index].id!);
              }
              setState(() {});
            },
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: AppScreenConfig.safeBlockVertical! * 40,
                  child: CachedNetworkImage(
                    imageUrl: moviesList?.results?[index].image?.url ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
                if (_selectedMoviesList
                    .contains(moviesList!.results![index].id)) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        _selectedMoviesList
                            .remove(moviesList.results![index].id);
                        setState(() {});
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 10.0)
                          ],
                        ),
                        child: const Icon(Icons.cancel_outlined,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _createPlaylistButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        )),
      ),
      onPressed: () async {
        try {
          List<Map<String, dynamic>> data = getAllSelectedMovies();
          var response =
              await FirebaseFirestore.instance.collection("user_playlist").add({
            "title": _titleController.text,
            "description": _descriptionController.text,
            "type": dropDownValue,
            "movies_list": data
          });
          print(response);

          await Utils.showSuccessToast("Your playlist is created successfully");
          context
              .read<PlaylistBloc>()
              .add(GetPlaylistEvent(dateTime: DateTime.now()));
        } catch (exe) {
          print(exe);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Text(
          'Create',
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getAllSelectedMovies() {
    List<Results> data = [];
    for (int i = 0; i < (moviesList?.results?.length ?? 0); i++) {
      for (int j = 0; j < (_selectedMoviesList.length); j++) {
        if (moviesList?.results?[i].id == _selectedMoviesList[j]) {
          data.add(moviesList!.results![i]);
        }
      }
    }

    return data.map((e) => e.toJson()).toList();
  }

  Widget _selectPublicPrivateDropdown() {
    return DropdownButtonFormField(
      focusColor: Colors.white,
      value: dropDownValue,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(10.0),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
      onChanged: (value) {
        setState(() {});
      },
      items: [
        DropdownMenuItem<String>(
          value: "Private",
          child: Text(
            "Private",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        DropdownMenuItem<String>(
          value: "Public",
          child: Text(
            "Public",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ],
    );
  }

  Widget _enterPlaylistTitle() {
    return TextFormField(
      controller: _titleController,
      cursorColor: LightAppColors.appBlueColor,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        hintMaxLines: 3,
        hintStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        fillColor: Colors.white,
        helperStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        labelText: 'Enter a playlist title',
      ),
      validator: (String? text) {
        if (text?.isEmpty ?? true) {
          return "Enter your playlist title";
        }

        return null;
      },
      onChanged: ((value) {}),
    );
  }

  Widget _enterPlaylistDescription() {
    return TextFormField(
      minLines: 3,
      maxLines: 8,
      controller: _descriptionController,
      cursorColor: LightAppColors.appBlueColor,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        hintStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        fillColor: Colors.white,
        helperStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        labelText: 'Enter a playlist description',
      ),
      validator: (String? text) {
        if (text?.isEmpty ?? true) {
          return "Enter your playlist description";
        }

        return null;
      },
      onChanged: ((value) {}),
    );
  }
}
