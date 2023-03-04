part of 'tv_detail_cubit.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends TvDetailState {
  final TvDetail result;
  final List<Tv> resultRecommendation;

  DetailHasData(this.result, this.resultRecommendation);

  @override
  List<Object> get props => [result, resultRecommendation];
}

class TvRecommendationHasData extends TvDetailState {
  final List<Tv> result;

  TvRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}
