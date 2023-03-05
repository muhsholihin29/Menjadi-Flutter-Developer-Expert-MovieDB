import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/usecases/tv/get_watchlist_tv_status.dart';
import '../../../domain/usecases/tv/get_watchlist_tvs.dart';
import '../../../domain/usecases/tv/remove_watchlist_tv.dart';
import '../../../domain/usecases/tv/save_watchlist_tv.dart';

part 'tv_watchlist_state.dart';

class TvWatchlistCubit extends Cubit<TvWatchlistState> {
  final GetWatchlistTvs getWatchlistTvs;
  final GetWatchListTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvWatchlistCubit({
    required this.getWatchlistTvs,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvWatchlistEmpty());

  Future<void> addWatchlist(TvDetail tv) async {
    emit(TvWatchlistLoading());
    final result = await saveWatchlist.execute(tv);
    result.fold(
      (failure) => emit(TvWatchlistError(failure.message)),
      (value) => emit(WatchlistMessageHasData(value)),
    );
    await loadWatchlistStatus(tv.id);
  }

  void deleteWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    result.fold(
      (failure) => emit(TvWatchlistError(failure.message)),
      (value) => emit(WatchlistMessageHasData(value)),
    );
    await loadWatchlistStatus(tv.id);
  }

  Future<void> getWatchlist() async {
    final result = await getWatchlistTvs.execute();
    result.fold(
          (failure) => emit(TvWatchlistError(failure.message)),
          (value) => emit(WatchlistHasData(value)),
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistStatusHasData(result));
  }
}
