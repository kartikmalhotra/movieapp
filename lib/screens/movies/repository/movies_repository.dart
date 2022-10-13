import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/screens/movies/model/movies_model.dart';
import 'package:movie/utils/utils.dart';

abstract class MoviesRepository {
  /// Getter and setter for movies list
  MoviesList? get moviesList;
  set moviesList(MoviesList? post);

  Future<dynamic> getMoviesList();

  Future<dynamic> getMoviesByTitle(String title);

  Future<dynamic> getMoviesBySearch(String search);
}

class MoviesRepositoryImpl extends MoviesRepository {
  MoviesList? _MoviesList;

  /// Getter and setter for movies list
  @override
  MoviesList? get moviesList => _MoviesList;

  @override
  set moviesList(MoviesList? data) {
    _MoviesList = data;
  }

  @override
  // set scheduledPost(ScheduledPostModel? post) {
  //   _scheduledPost = post;
  // }

  Future<dynamic> getMoviesList() async {
    try {
      var headers = {
        'X-RapidAPI-Key': '8b1b0fbca2msh001fbfb64212303p19f86djsn0e13699c96de'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://imdb8.p.rapidapi.com/title/v2/find?title=new%20of&limit=20'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        await Utils.showSuccessToast(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  @override
  Future<dynamic> getMoviesByTitle(String title) async {
    try {
      var response = await http.get(Uri.parse(
          'https://imdb8.p.rapidapi.com/title/v2/find?title=${title}%20of&limit=20'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      print(e);
      return {};
    }
  }

  @override
  Future<dynamic> getMoviesBySearch(String title) async {
    try {
      var headers = {
        'X-RapidAPI-Key': '8b1b0fbca2msh001fbfb64212303p19f86djsn0e13699c96de'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://imdb8.p.rapidapi.com/title/v2/find?title=$title%20of&limit=20'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        await Utils.showSuccessToast(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
      return {};
    }
  }
}
