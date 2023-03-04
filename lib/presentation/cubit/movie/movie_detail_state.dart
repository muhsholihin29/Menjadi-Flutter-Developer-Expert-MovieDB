part of 'movie_detail_cubit.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends MovieDetailState {
  final MovieDetail result;
  final List<Movie> resultRecommendation;

  DetailHasData(this.result, this.resultRecommendation);

  @override
  List<Object> get props => [result, resultRecommendation];
}

class MovieRecommendationHasData extends MovieDetailState {
  final List<Movie> result;

  MovieRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}
