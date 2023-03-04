part of 'tv_watchlist_cubit.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMessageHasData extends TvWatchlistState {
  final String result;

  WatchlistMessageHasData(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistStatusHasData extends TvWatchlistState {
  final bool result;

  WatchlistStatusHasData(this.result);

  @override
  List<Object> get props => [result];
}
