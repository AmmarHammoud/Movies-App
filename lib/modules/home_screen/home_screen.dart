import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/home_screen/cubit/coming_soon_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/coming_soon_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/cubit/most_popular_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/most_popular_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/cubit/top_movies_cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/cubit/top_movies_cubit/states.dart';
import 'package:flutter_app2/modules/home_screen/search_screen/search_screen.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/states.dart';
import 'package:flutter_app2/modules/movie_screen/movie_screen.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
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
              navigateTo(context, SearchScreen());
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
    );
  }

  Widget buildMostPopularMoviesList() {
    return BlocProvider(
      create: (context) => MostPopularMoviesCubit()..getMostPopularMovies(),
      child: BlocConsumer<MostPopularMoviesCubit, MostPopularMoviesStates>(
        listener: (context, state) {},
        builder: (context, state) {
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
                navigateTo(
                    context,
                    MovieScreen(item.image, item.title, item.year, item.rating,
                        item.id));
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
