import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

class TvListNotifier extends ChangeNotifier {
  var _onTheAirTvs = <Tv>[];

  List<Tv> get onTheAirTvs => _onTheAirTvs;

  RequestState _onTheAirState = RequestState.Empty;

  RequestState get onTheAirState => _onTheAirState;

  var _popularTvs = <Tv>[];

  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvsState = RequestState.Empty;

  RequestState get popularTvsState => _popularTvsState;

  var _topRatedTvs = <Tv>[];

  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.Empty;

  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';

  String get message => _message;

  TvListNotifier({
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  });

  final GetOnTheAirTvs getOnTheAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _onTheAirState = RequestState.Loaded;
        _onTheAirTvs = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        _popularTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _popularTvsState = RequestState.Loaded;
        _popularTvs = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        _topRatedTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _topRatedTvsState = RequestState.Loaded;
        _topRatedTvs = moviesData;
        notifyListeners();
      },
    );
  }
}
