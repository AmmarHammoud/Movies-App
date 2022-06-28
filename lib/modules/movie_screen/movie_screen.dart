import 'dart:developer';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/models/single_movie_model.dart';
import 'package:flutter_app2/models/user_model.dart';
import 'package:flutter_app2/modules/favourites_screen/favourites_screen.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/movie_tariler_cubit/cubit.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/movie_tariler_cubit/states.dart';
import 'package:flutter_app2/modules/movie_screen/cubit/states.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieScreen extends StatelessWidget {
  final String id;
  final UserModel model;
  ///if the user came from favourite screen and return back,
  ///the list in favourite screen must be updated,
  ///and the responsible of this update is [fromFav],
  ///which will be sent to favourite screen to  as [true] to handle this.
  final bool fromFav;

  MovieScreen(this.id, this.model, this.fromFav);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetMovieDetailsCubit()..getMovieDetails(id, model.uId),
      child: BlocConsumer<GetMovieDetailsCubit, GetMovieDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ///SingleMovieModel [smm]
          var smm = GetMovieDetailsCubit.get(context).smm;
          var actors = smm?.actors;
          bool isFav = GetMovieDetailsCubit.get(context).isFav;
          return ConditionalBuilder(
            condition: state is! GetMovieDetailsLoadingState,
            builder: (context) => Scaffold(
              appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Text('Movie\'s Details'),
                  leading: fromFav
                      ? IconButton(
                          onPressed: () {
                            navigateAndFinish(
                                context, FavouritesScreen(model, true));
                          },
                          icon: Icon(Icons.arrow_back))
                      : null),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image(
                              height: 350.0,
                              fit: BoxFit.cover,
                              image: NetworkImage('${smm?.image}'),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${smm?.title} ${smm?.year}',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.white),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Rating: ${smm?.rating}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontSize: 25.0),
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.yellow[700],
                                size: 25.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.heart_broken,
                                color: isFav ? Colors.red : Colors.white,
                              ),
                              onPressed: () {
                                GetMovieDetailsCubit.get(context)
                                    .updateFavourites(
                                        model,
                                        SingleMovieModel(
                                            title: '${smm?.title}',
                                            image: '${smm?.image}',
                                            id: id,
                                            year: '${smm?.year}',
                                            rating: '${smm?.rating}',
                                            description: '${smm?.description}',
                                            actors: smm?.actors));
                              }),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            'Description:',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              '${smm?.description}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(fontSize: 20.0),
                            ),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            'Official Trailer:',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          buildTrailer(),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            'Actors:',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Container(
                            width: double.infinity,
                            height: 130.0,
                            child: ListView.separated(
                              //controller: controller,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => buildActors(
                                  actors?[index].image,
                                  actors?[index].name,
                                  actors?[index].asWho),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 10.0,
                              ),
                              itemCount: actors!.length,
                            ),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget buildActors(String image, String actorName, String asWho) {
    return Container(
      width: 100.0,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.grey[400],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image(
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 30.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Marquee(
              text: actorName + ' As: ' + asWho,
              velocity: 25.0,
              blankSpace: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTrailer() {
    return BlocProvider(
      create: (context) => MovieTrailerCubit()..getMovieTrailer(id),
      child: BlocConsumer<MovieTrailerCubit, MovieTrailerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var ID = MovieTrailerCubit.get(context).model?.id;
          YoutubePlayerController controller = YoutubePlayerController(
            initialVideoId: '${ID}',
            params: YoutubePlayerParams(
              playlist: ['${ID}'],
              startAt: const Duration(minutes: 0, seconds: 0),
              showControls: true,
              showFullscreenButton: true,
              desktopMode: false,
              privacyEnhanced: true,
              useHybridComposition: true,
            ),
          );
          const player = YoutubePlayerIFrame();
          controller.onEnterFullscreen = () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            log('Entered Fullscreen');
          };
          controller.onExitFullscreen = () {
            log('Exited Fullscreen');
          };
          return ConditionalBuilder(
            condition: state is! MovieTrailerLoadingState,
            builder: (context) => YoutubePlayerControllerProvider(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Stack(
                  children: [
                    player,
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        controller: controller,
                        builder: (context, value) {
                          return AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Material(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayerController.getThumbnail(
                                        videoId:
                                            controller.params.playlist.first,
                                        quality: ThumbnailQuality.medium,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            crossFadeState: value.isReady
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
