import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/favourites_screen/favourites_screen.dart';
import 'package:flutter_app2/modules/home_screen/cubit/coming_soon_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/coming_soon_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/cubit/most_popular_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/most_popular_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/cubit/top_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/top_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/search_screen/search_screen.dart';
import 'package:flutter_app2/modules/login_screen/login_screen.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/states.dart';
import 'package:flutter_app2/modules/movie_screen/movie_screen.dart';
import 'package:flutter_app2/modules/profile_screen/profile_screen.dart';
import 'package:flutter_app2/shared/chach_helper.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel model;

  HomeScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigateTo(context, SearchScreen(model));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitles(context, 'Most Popular Movies'),
            buildMostPopularMoviesList(),
            buildTitles(context, 'Top Movies'),
            buildTopMoviesList(),
            buildTitles(context, 'Coming Soon'),
            buildComingSoonMoviesList(),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Text('Welcome, ${model.userName}'),
            SizedBox(height: 25.0,),
            TextButton(
              child: Text('favourite', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                navigateTo(context, FavouritesScreen(model, false));
              },
            ),
            TextButton(
              child: Text('edit profile', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                navigateTo(context, ProfileScreen(model));
              },
            ),
            TextButton(
              child: Text('log out', style: TextStyle(color: Colors.red),),
              onPressed: () {
                CachHelper.putBoolean(key: 'login', value: false);
                FirebaseAuth.instance.signOut();
                navigateAndFinish(
                    context,
                    LoginScreen(
                      model: model,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMostPopularMoviesList() {
    return BlocProvider(
      create: (context) => MostPopularMoviesCubit()..getMostPopularMovies(),
      child: BlocConsumer<MostPopularMoviesCubit, MostPopularMoviesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ///MostPopularMovies [mpm]
          var mpm = MostPopularMoviesCubit.get(context).mpm?.items;
          return ConditionalBuilder(
            condition: state is! GetMostPopularMoviesLoadingState,
            builder: (context) => Container(
              width: double.infinity,
              height: 215.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildMovieItem(mpm?[index]);
                },
                itemCount: mpm?.length,
              ),
            ),
            fallback: (context) => Center(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget buildTopMoviesList() {
    return BlocProvider(
      create: (context) => TopMoviesCubit()..getTopMovies(),
      child: BlocConsumer<TopMoviesCubit, TopMoviesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ///TopMovies [tm]
          var tm = TopMoviesCubit.get(context).top250?.items;
          return ConditionalBuilder(
            condition: state is! GetTopMoviesLoadingState,
            builder: (context) => Container(
              width: double.infinity,
              height: 215.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildMovieItem(tm?[index]);
                },
                itemCount: tm?.length,
              ),
            ),
            fallback: (context) => Center(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget buildComingSoonMoviesList() {
    return BlocProvider(
      create: (context) => ComingSoonCubit()..getComingSoon(),
      child: BlocConsumer<ComingSoonCubit, ComingSoonStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ///ComingSoon [cs]
          var cs = ComingSoonCubit.get(context).cs?.items;
          return ConditionalBuilder(
            condition: state is! GetComingSoonLoadingState,
            builder: (context) => Container(
              width: double.infinity,
              height: 215.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildMovieItem(cs?[index]);
                },
                itemCount: cs?.length,
              ),
            ),
            fallback: (context) => Center(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget buildMovieItem(item) {
    return BlocProvider(
      create: (context) => GetMovieDetailsCubit(),
      child: BlocConsumer<GetMovieDetailsCubit, GetMovieDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: InkWell(
              onTap: () {
                navigateTo(context, MovieScreen(item.id, model, false));
              },
              child: Container(
                width: 125.0,
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
                          image: NetworkImage('${item?.image}'),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item?.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item?.year}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTitles(context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 27.0),
      ),
    );
  }
}
