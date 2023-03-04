part of 'movie_watchlist_cubit.dart';

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistEmpty extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistMessageHasData extends MovieWatchlistState {
  final String result;

  MovieWatchlistMessageHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MovieWatchlistStatusHasData extends MovieWatchlistState {
  final bool result;

  MovieWatchlistStatusHasData(this.result);

  @override
  List<Object> get props => [result];
}
