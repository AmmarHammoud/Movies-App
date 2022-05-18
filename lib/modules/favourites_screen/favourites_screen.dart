import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/favourites_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/favourites_screen/cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/home_screen.dart';
import 'package:flutter_app2/modules/movie_screen/movie_screen.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesScreen extends StatelessWidget {
  UserModel model;
  bool afterUnfav;
  List<Widget> widgets = [];

  FavouritesScreen(this.model, this.afterUnfav);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetFavouriteMoviesCubit()..getFavouriteMovies(model),
      child: BlocConsumer<GetFavouriteMoviesCubit, GetFavouriteMoviesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var favMovies = GetFavouriteMoviesCubit.get(context).favMovies;
          return ConditionalBuilder(
              condition: state is! GetFavouriteMoviesLoadingState,
              builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Favourites'),
                    leading: afterUnfav
                        ? IconButton(
                            onPressed: () {
                              navigateTo(context, HomeScreen(model: model));
                            },
                            icon: Icon(Icons.arrow_back))
                        : null,
                  ),
                  body: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildMovies(
                          context: context,
                          movieTitle: favMovies[index]['title']![0],
                          image: favMovies[index]['title']![4],
                          year: favMovies[index]['title']![2],
                          rating: favMovies[index]['title']![3],
                          id: favMovies[index]['title']![1]),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                      itemCount: favMovies.length)),
              fallback: (context) => Center(
                    child: CircularProgressIndicator(),
                  ));
        },
      ),
    );
  }

  Widget buildMovies(
      {required context,
      required String movieTitle,
      required String image,
      required String year,
      required String rating,
      required String id}) {
    return InkWell(
      onTap: () {
        navigateTo(context, MovieScreen(id, model, true));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 125.0,
            height: 175.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey[300],
            ),
          ),
          Text(
            movieTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
/*
ListView.separated(itemBuilder: (context, index) => buildMovies(movies),
            separatorBuilder: (context, index) => SizedBox(width: 10,),
            itemCount: 10))*/
