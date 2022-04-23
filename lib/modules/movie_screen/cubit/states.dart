abstract class GetMovieDetailsStates{}

class GetMovieDetailsInitialState extends GetMovieDetailsStates{}

class GetMovieDetailsSuccessState extends GetMovieDetailsStates{}

class GetMovieDetailsLoadingState extends GetMovieDetailsStates{}

class GetMovieDetailsErrorState extends GetMovieDetailsStates{}

class FavouriteMovie extends GetMovieDetailsStates{}

class NotFavouriteMovie extends GetMovieDetailsStates{}
